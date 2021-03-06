class Question < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_one :badge, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :votable
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  scope :all_created_last_day, -> { Question.where(created_at: Time.current.all_day) }

  after_create :create_subscription

  private

  def create_subscription
    self.subscriptions.create(user: author)
  end
end
