class Brewery < ActiveRecord::Base
  include RatingAverage
  extend Top

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1040 }

  validate :year_cannot_be_in_the_future

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_cannot_be_in_the_future
    errors.add(:year, "can't be in the future") if year.present? && year > Time.now.year
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2018
    puts "changed year to #{year}"
  end
end
