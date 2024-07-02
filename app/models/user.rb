class User < ApplicationRecord
  # 1. Associations
  has_many :sessions, dependent: :destroy
  has_many :tweets, dependent: :destroy

  # 2. Validations
  validates :username, presence: true, length: { minimum: 3, maximum: 64 }, uniqueness: true
  validates :email, presence: true, length: { minimum: 5, maximum: 500 }, uniqueness: true
  validates :password, presence: true, length: { minimum: 8, maximum: 64 }

  # 3. Authentication
  has_secure_password

  # 4. Callbacks
  before_save { self.email = email.downcase }

  # Optional: Method to generate a token (e.g., for sessions)
  def generate_token
    SecureRandom.urlsafe_base64
  end
end

