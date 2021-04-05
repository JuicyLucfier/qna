class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, class_name: 'Question', foreign_key: :author_id, dependent: :destroy
  has_many :answers, class_name: 'Answer', foreign_key: :author_id, dependent: :destroy
  has_many :comments, class_name: 'Comment', foreign_key: :author_id, dependent: :destroy
  has_many :user_badges, dependent: :destroy
  has_many :badges, through: :user_badges
  has_many :votes, dependent: :destroy

  scope :all_except, ->(user) { where("id != ?", user.id) }

  def author_of?(subject)
    id == subject.author_id
  end

  def voted?(subject)
    vote(subject).present?
  end

  def vote(subject)
    votes.find_by(votable: subject)
  end
end
