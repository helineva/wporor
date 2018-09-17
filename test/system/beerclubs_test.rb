require "application_system_test_case"

class BeerclubsTest < ApplicationSystemTestCase
  setup do
    @beerclub = beerclubs(:one)
  end

  test "visiting the index" do
    visit beerclubs_url
    assert_selector "h1", text: "Beerclubs"
  end

  test "creating a Beerclub" do
    visit beerclubs_url
    click_on "New Beerclub"

    fill_in "City", with: @beerclub.city
    fill_in "Founded", with: @beerclub.founded
    fill_in "Name", with: @beerclub.name
    click_on "Create Beerclub"

    assert_text "Beerclub was successfully created"
    click_on "Back"
  end

  test "updating a Beerclub" do
    visit beerclubs_url
    click_on "Edit", match: :first

    fill_in "City", with: @beerclub.city
    fill_in "Founded", with: @beerclub.founded
    fill_in "Name", with: @beerclub.name
    click_on "Update Beerclub"

    assert_text "Beerclub was successfully updated"
    click_on "Back"
  end

  test "destroying a Beerclub" do
    visit beerclubs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Beerclub was successfully destroyed"
  end
end
