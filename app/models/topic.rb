class Topic < ApplicationRecord
  has_many :posts
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 5 }, presence: true
  mount_uploader :image, ImageUploader
end
