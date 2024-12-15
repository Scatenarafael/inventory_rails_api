class User < ApplicationRecord
  has_secure_password
  # mount_uploader :avatar, AvatarUploader

  # enum role: {
  #   mantainer: 0,
  #   admin: 1,
  #   operator: 2
  # }

  has_many :item

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
