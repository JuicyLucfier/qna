class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  GIST_URL_REGEXP = /^https?:\/{2}gist.github.com\/\w+\/\w+/.freeze

  def gist?
    url.match?(GIST_URL_REGEXP)
  end
end
