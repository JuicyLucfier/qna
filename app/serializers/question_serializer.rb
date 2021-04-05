class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :files

  belongs_to :author, class_name: 'User', foreign_key: :author_id

  has_many :answers
  has_many :comments
  has_many :links

  def files
    object.files.map { |file| { url: rails_blob_path(file, only_path: true) } }
  end
end
