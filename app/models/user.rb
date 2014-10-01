class User < ActiveRecord::Base
  # attr_reader :password_digest
  attr_reader :password
  validates :username, :password_digest, presence: :true

  after_initialize :set_session_token

  has_many :cats
  has_many :cat_rental_requests

  def self.generate_session_token
    SecureRandom::urlsafe_base64(16)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    self.save!
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def reset_session_token
    self.session_token = self.class.generate_session_token
  end

  def set_session_token
    self.session_token ||= self.class.generate_session_token
  end

end
