class Rating < ApplicationRecord
  belongs_to :beer
  belongs_to :user
  has_one :brewery, through: :beer

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  def to_s
    "#{beer.name} #{score}"
  end
end
