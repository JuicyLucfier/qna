class Answer < ApplicationRecord
  default_scope { order(best: :desc) }

  belongs_to :author, class_name: 'User', foreign_key: :author_id
  belongs_to :question

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true
  validate :validate_best_answer_present, on: :create, if: :best?

  def change_mark
    if best?
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

  def validate_best_answer_present
    errors.add(:best) if question.answers.find_by(best: true).present?
  end
end
