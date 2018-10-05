require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved with a name, style and brewery" do
    test_brewery = Brewery.create name:"testbrewery", year:1900
    test_style = Style.create name:"Lager", description:"A style."
    test_beer = Beer.create name:"testbeer", style:test_style, brewery:test_brewery

    expect(test_beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end

  it "is not saved if name is not given" do
    test_brewery = Brewery.create name:"testbrewery", year:1900
    test_style = Style.create name:"Lager", description:"A style."
    test_beer = Beer.create style:test_style, brewery:test_brewery

    expect(test_beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved if style is not given" do
    test_brewery = Brewery.create name:"testbrewery", year:1900
    test_beer = Beer.create name:"testbeer", brewery:test_brewery

    expect(test_beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end
end
