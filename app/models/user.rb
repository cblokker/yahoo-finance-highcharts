class User < ActiveRecord::Base
  has_many :investments
  has_many :stocks, through: :investments

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    
  validates :password, length: { minimum: 6 }

  has_secure_password

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    return user if user && (user.authenticate(password))
    nil
  end
end
