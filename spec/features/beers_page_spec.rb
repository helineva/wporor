require 'rails_helper'

describe "Beers page" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }

  it "is saved if name is valid" do
    visit new_beer_path

    fill_in('beer[name]', with:'beer')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "is not saved if name is not valid" do
    visit new_beer_path

    click_button "Create Beer"

    expect(Beer.count).to eq(0)
    expect(page).to have_content "Name can't be blank"
  end
end