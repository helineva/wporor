class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :beerclub

  validates :user, uniqueness: { scope: :beerclub }
end
