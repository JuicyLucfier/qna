class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at

  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_many :answers
end