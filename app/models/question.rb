class Question < ApplicationRecord
  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_many :answers, dependent: :destroy

  has_many_attached :files, dependent: :destroy

  validates :title, :body, presence: true
end
