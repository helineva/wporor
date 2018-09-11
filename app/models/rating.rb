class Rating < ApplicationRecord
  belongs_to :beer

  def to_s
    return "#{self.beer.name} #{self.score}"
  end
end
