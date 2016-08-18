class Topic < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  max_paginates_per 5
  paginates_per 5
  has_many :posts
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 5 }, presence: true
  mount_uploader :image, ImageUploader
  belongs_to :user
end
