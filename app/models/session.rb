class Session < ApplicationRecord
  belongs_to :user
  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64  # Ensure token is generated before creating session
  end
end

