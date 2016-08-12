class Comment < ApplicationRecord
  belongs_to :post
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 5 }, presence: true
  belongs_to :user
  paginates_per 5
  max_paginates_per 5
end
