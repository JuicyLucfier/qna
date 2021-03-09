class Answer < ApplicationRecord
  default_scope { order(best: :desc) }

  belongs_to :author, class_name: 'User', foreign_key: :author_id
  belongs_to :question

  validates :body, presence: true
  validate :validate_best_answer_present, on: :create, if: :best_answer?

  def change_mark
    if best_answer?
      self.best = false
    else
      unmark_previous_answer(question) if best_answer(question).present?
      self.best = true
    end

    self.save
  end

  private

  def best_answer(question)
    question.answers.find_by(best: true)
  end

  def unmark_previous_answer(question)
    answer = best_answer(question)
    answer.best = false
    answer.save
  end

  def best_answer?
    self.best == true
  end

  def validate_best_answer_present
    errors.add(:best) if question.answers.find_by(best: true).present?
  end
end
