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
      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style of beers of highest average rating" do
      create_beer_with_rating({ user: user }, 20, style:"Lager")
      create_beers_with_many_ratings({ user: user }, [32, 28], style:"Weizen")
      create_beers_with_many_ratings({ user: user }, [22,23,24], style:"IPA")

      expect(user.favorite_style).to eq("Weizen")
    end
  end
end

def create_beer_with_rating(object, score, style:"Lager")
  beer = FactoryBot.create(:beer, style:style)
  FactoryBot.create(:rating, beer:beer, score:score, user:object[:user])
  beer
end

def create_beers_with_many_ratings(object, scores, style:"Lager")
  scores.each do |score|
    create_beer_with_rating(object, score, style:style)
  end
end
