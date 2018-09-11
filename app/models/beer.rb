class Beer < ActiveRecord::Base
  belongs_to :brewery
  has_many :ratings

  def average_rating
    count = self.ratings.count
    return nil if count == 0
    total = self.ratings.reduce(0) {|sum,r| sum + r.score}
    return total.fdiv(count).round(2)
  end

  def to_s
    return "#{self.name} by #{self.brewery.name}"
  end

end
