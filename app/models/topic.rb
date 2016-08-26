class Topic < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged
  max_paginates_per 5
  paginates_per 5
  has_many :posts
  validates :title, length: { minimum: 5 }, presence: true
  validates :description, length: { minimum: 5 }, presence: true
  validates :user_id, presence: true
  mount_uploader :image, ImageUploader
  belongs_to :user
  before_save :update_slug
  validate :image_size

  private

  def update_slug
    if self.slug.gsub("","-") != title.gsub(" ","-")
      self.slug = title.gsub(" ","-").downcase
    end
  end

  def image_size
   return unless image
   if image.size > 1.megabyte
     errors.add(:file, "size is too big. Please make sure it is 1MB or smaller.")
   end
 end
end
