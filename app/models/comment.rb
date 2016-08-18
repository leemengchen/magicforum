class Comment < ApplicationRecord
  extend FriendlyId
  friendly_id :body, use: :slugged
  belongs_to :post
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 5 }, presence: true
  belongs_to :user
  paginates_per 5
  max_paginates_per 5
  has_many :votes

  def total_votes
    votes.pluck(:value).sum
  end
end
