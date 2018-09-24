require 'rails_helper'

include Helpers

describe "User page" do
  let!(:user1) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "James" }

  it "contains all the user's ratings and no-one else's ratings" do
    brewery = FactoryBot.create :brewery, name:"Koff"
    beer1 = FactoryBot.create :beer, name:"iso 3", brewery:brewery
    beer2 = FactoryBot.create :beer, name:"Karhu", brewery:brewery
    rating1 = FactoryBot.create :rating, beer:beer1, user:user1, score:20
    rating2 = FactoryBot.create :rating, beer:beer2, user:user1, score:30
    rating3 = FactoryBot.create :rating, beer:beer1, user:user2, score:40
    visit user_path(user1)

    expect(all('ul')[1]).to have_selector('li', count:user1.ratings.count)
  end
end
