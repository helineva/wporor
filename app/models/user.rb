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

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    favorite_style_id = ratings.joins(:beer)
                               .group('style_id')
                               .select('AVG(score) as avg, style_id')
                               .order('avg desc')
                               .limit(1)
                               .first['style_id']
    Style.find(favorite_style_id).name
  end

  def favorite_brewery
    return nil if ratings.empty?

    ratings.joins(:brewery)
           .group('breweries.name')
           .select('AVG(score) as avg, breweries.name as name')
           .order('avg desc')
           .first
           .name
  end
end
