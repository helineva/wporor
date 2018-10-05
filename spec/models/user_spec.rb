require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a too short password" do
    user = User.create username:"Pekka", password:"pW1", password_confirmation:"pW1"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "is not saved with a password consisting of letters only" do
    user = User.create username:"Pekka", password:"onlyletters", password_confirmation:"onlyletters"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }

    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score:10, user:user)
      FactoryBot.create(:rating, score:20, user:user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating({ user:user }, 10)
      create_beer_with_rating({ user:user }, 7)
      best = create_beer_with_rating({ user:user }, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without rating has none" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only rated beer if only one rating" do
      beer = create_beer_with_rating({ user:user }, 20)
      expect(user.favorite_style).to eq(beer.style.name)
    end

    it "is the style of beers of highest average rating" do
      create_beer_with_rating({ user: user }, 20, style_name:"Lager")
      create_beers_with_many_ratings({ user: user }, [32, 28], style_name:"Weizen")
      create_beers_with_many_ratings({ user: user }, [22,23,24], style_name:"IPA")

      expect(user.favorite_style).to eq("Weizen")
    end
  end

  describe "favorite brewery" do
    let(:user) { FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without rating has none" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only rated beer if only one rating" do
      beer = create_beer_with_rating({ user:user }, 20)
      expect(user.favorite_brewery).to eq(beer.brewery.name)
    end

    it "is the brewery of beers of highest average rating" do
      brewery1 = FactoryBot.create(:brewery, name:"brewery1")
      brewery2 = FactoryBot.create(:brewery, name:"brewery2")
      brewery3 = FactoryBot.create(:brewery, name:"brewery3")
      style1 = FactoryBot.create(:style, name:"style1")
      style2 = FactoryBot.create(:style, name:"style2")
      style3 = FactoryBot.create(:style, name:"style3")
      beer1 = FactoryBot.create(:beer, name:"beer1", style:style1, brewery:brewery1)
      beer2 = FactoryBot.create(:beer, name:"beer2", style:style2, brewery:brewery2)
      beer3 = FactoryBot.create(:beer, name:"beer3", style:style3, brewery:brewery2)
      beer4 = FactoryBot.create(:beer, name:"beer4", style:style1, brewery:brewery3)
      beer5 = FactoryBot.create(:beer, name:"beer5", style:style1, brewery:brewery3)
      beer6 = FactoryBot.create(:beer, name:"beer6", style:style2, brewery:brewery3)
      FactoryBot.create(:rating, score: 20, beer: beer1, user: user)
      FactoryBot.create(:rating, score: 32, beer: beer2, user: user)
      FactoryBot.create(:rating, score: 28, beer: beer3, user: user)
      FactoryBot.create(:rating, score: 22, beer: beer4, user: user)
      FactoryBot.create(:rating, score: 23, beer: beer5, user: user)
      FactoryBot.create(:rating, score: 24, beer: beer6, user: user)

      expect(user.favorite_brewery).to eq(brewery2.name)
    end
  end
end

def create_beer_with_rating(object, score, style_name:"Lager")
  style = FactoryBot.create(:style, name:style_name)
  beer = FactoryBot.create(:beer, style:style)
  FactoryBot.create(:rating, beer:beer, score:score, user:object[:user])
  beer
end

def create_beers_with_many_ratings(object, scores, style_name:"Lager")
  scores.each do |score|
    create_beer_with_rating(object, score, style_name:style_name)
  end
end
