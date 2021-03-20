class Badge < ApplicationRecord
  belongs_to :question

  has_one_attached :image, dependent: :destroy

  has_many :user_badges, dependent: :destroy
  has_many :users, through: :user_badges

  validates :title, presence: true
  validates :image, attached: true,
            content_type: ['image/png', 'image/jpg']
end
