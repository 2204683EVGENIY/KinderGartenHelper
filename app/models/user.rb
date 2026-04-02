class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :mentor

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :password, :email_address, presence: { message: "Must presence." }
end
