module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    count = self.ratings.count
    return nil if count == 0
    total = self.ratings.reduce(0) {|sum,r| sum + r.score}
    return total.fdiv(count).round(2)
  end
end
