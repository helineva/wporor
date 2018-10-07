require 'rails_helper'

include Helpers

describe "User page" do
  let!(:style1) { FactoryBot.create :style }
  let!(:style2) { FactoryBot.create :style, name: "Weizen" }
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

    expect(find('ul', id:'ratings-list')).to have_selector('li', count:user1.ratings.count)
    expect(page).to have_content "#{beer1.name} #{rating1.score}"
    expect(page).to have_content "#{beer2.name} #{rating2.score}"
  end

  it "when signed in, can be used to delete user's own ratings" do
    sign_in(username: "Pekka", password: "Foobar1")
    brewery = FactoryBot.create :brewery, name:"Koff"
    beer = FactoryBot.create :beer, name:"iso 3", brewery:brewery
    rating1 = FactoryBot.create :rating, beer:beer, user:user1, score:20
    rating2 = FactoryBot.create :rating, beer:beer, user:user1, score:30

    visit user_path(user1)

    expect(user1.ratings.count).to eq(2)
    page.find('li', text: "#{beer.name} #{rating2.score}").click_link('delete')

    expect(user1.ratings.count).to eq(1)
    expect(Rating.exists?(rating2.id)).to be(false)
  end

  it "shows user's favorite style" do
    brewery = FactoryBot.create :brewery, name:"Koff"
    beer1 = FactoryBot.create :beer, name:"iso 3", style:style1, brewery:brewery
    beer2 = FactoryBot.create :beer, name:"Weizenolut", style:style2, brewery:brewery

    rating1 = FactoryBot.create :rating, beer:beer1, user:user1, score:20
    rating2 = FactoryBot.create :rating, beer:beer2, user:user1, score:30

    visit user_path(user1)

    expect(page).to have_content "Favorite style: #{style2.name}"
  end

  it "shows user's favorite brewery" do
    brewery1 = FactoryBot.create :brewery, name:"Koff"
    brewery2 = FactoryBot.create :brewery, name:"Boff"
    beer1 = FactoryBot.create :beer, name:"iso 3", brewery:brewery1
    beer2 = FactoryBot.create :beer, name:"Karhu", brewery:brewery2

    rating1 = FactoryBot.create :rating, beer:beer1, user:user1, score:20
    rating2 = FactoryBot.create :rating, beer:beer2, user:user1, score:30

    visit user_path(user1)

    expect(page).to have_content "Favorite brewery: #{brewery2.name}"
  end
end
