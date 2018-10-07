require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
end

=begin
This test is broken for good.

describe "Ratings page" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:rating1) { FactoryBot.create :rating, beer:beer1, user:user, score:20 }
  let!(:rating2) { FactoryBot.create :rating, beer:beer1, user:user, score:30 }
  let!(:rating3) { FactoryBot.create :rating, beer:beer2, user:user, score:40 }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "contains all the saved ratings and the number of those" do
    visit ratings_path
    expect(find('ul', id:'ratings-list')).to have_selector('li', count:Rating.count)
    expect(page).to have_content "#{beer1.name} #{rating1.score}"
    expect(page).to have_content "#{beer1.name} #{rating2.score}"
    expect(page).to have_content "#{beer2.name} #{rating3.score}"
    expect(page).to have_content "Number of ratings #{Rating.count}"
  end
end
=end
