module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    count = ratings.count
    return 0 if count.zero?

    total = ratings.reduce(0) { |sum, r| sum + r.score }
    total.fdiv(count)
  end
end
