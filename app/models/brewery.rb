class Brewery < ActiveRecord::Base
  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2018
    puts "changed year to #{year}"
  end

  def average_rating
    count = self.ratings.count
    return nil if count == 0
    total = self.ratings.reduce(0) {|sum,r| sum + r.score}
    return total.fdiv(count).round(2)
  end
end
