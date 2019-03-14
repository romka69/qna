class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, url: true

  def gist_url?
    url.match?(/gist.github.com\/.+\/.+/)
  end
end
