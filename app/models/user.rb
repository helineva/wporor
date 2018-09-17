class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beerclubs, through: :memberships

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }
  validates :password, length: { minimum: 4 }
  validate :password_must_contain_capital_letter
  validate :password_must_contain_number

  def password_must_contain_capital_letter
    errors.add(:password, "must contain a capital letter") if password.present? && password !~ /.*[A-Z].*/
  end

  def password_must_contain_number
    errors.add(:password, "must contain a number") if password.present? && password !~ /.*[0-9].*/
  end
end
