class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :title, :body, :created_at, :updated_at, :files

  has_many :comments
  has_many :links

  def files
    object.files.map { |file| { url: rails_blob_path(file, only_path: true) } }
  end
end
