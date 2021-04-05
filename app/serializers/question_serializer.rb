class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_many :answers

  def short_title
    object.title.truncate(7)
  end
end
