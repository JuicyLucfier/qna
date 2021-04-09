class UserSubscription < ApplicationRecord
  belongs_to :subscriber, class_name: 'User', foreign_key: :user_id
  belongs_to :subscriptions, class_name: 'Question', foreign_key: :question_id
end
