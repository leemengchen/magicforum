class Comment < ApplicationRecord
  belongs_to :post
  mount_uploader :image, ImageUploader
  validates :body, length: { minimum: 5 }, presence: true
end
