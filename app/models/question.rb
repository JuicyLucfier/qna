class Question < ApplicationRecord
  include Votable

  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_one :badge, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :votes, dependent: :destroy, as: :votable
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :user_subscriptions, dependent: :destroy
  has_many :subscribers, class_name: 'User', through: :user_subscriptions

  has_many_attached :files, dependent: :destroy

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank

  validates :title, :body, presence: true

  scope :all_created_last_day, -> { select { |question| question.created_last_day? } }

  def created_last_day?
    (Time.now - created_at).to_i / 3600 <= 24
  end
end
