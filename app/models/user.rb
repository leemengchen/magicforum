class User < ApplicationRecord
  has_secure_password
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, presence: true , uniqueness: true
  validates :password, length: { minimum: 5, message:"password length must be 5 characters above!!"  }, presence: true, on: :create

  mount_uploader :image, ImageUploader
  has_many :posts
  has_many :topics
  has_many :comments
  enum role: [:user, :moderator, :admin]
  has_many :votes

end
