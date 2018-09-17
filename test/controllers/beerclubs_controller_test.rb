require 'test_helper'

class BeerclubsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @beerclub = beerclubs(:one)
  end

  test "should get index" do
    get beerclubs_url
    assert_response :success
  end

  test "should get new" do
    get new_beerclub_url
    assert_response :success
  end

  test "should create beerclub" do
    assert_difference('Beerclub.count') do
      post beerclubs_url, params: { beerclub: { city: @beerclub.city, founded: @beerclub.founded, name: @beerclub.name } }
    end

    assert_redirected_to beerclub_url(Beerclub.last)
  end

  test "should show beerclub" do
    get beerclub_url(@beerclub)
    assert_response :success
  end

  test "should get edit" do
    get edit_beerclub_url(@beerclub)
    assert_response :success
  end

  test "should update beerclub" do
    patch beerclub_url(@beerclub), params: { beerclub: { city: @beerclub.city, founded: @beerclub.founded, name: @beerclub.name } }
    assert_redirected_to beerclub_url(@beerclub)
  end

  test "should destroy beerclub" do
    assert_difference('Beerclub.count', -1) do
      delete beerclub_url(@beerclub)
    end

    assert_redirected_to beerclubs_url
  end
end
