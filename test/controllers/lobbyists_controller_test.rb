require 'test_helper'

class LobbyistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lobbyist = lobbyists(:one)
  end

  test "should get index" do
    get lobbyists_url
    assert_response :success
  end

  test "should get new" do
    get new_lobbyist_url
    assert_response :success
  end

  test "should create lobbyist" do
    assert_difference('Lobbyist.count') do
      post lobbyists_url, params: { lobbyist: { description: @lobbyist.description, name: @lobbyist.name } }
    end

    assert_redirected_to lobbyist_url(Lobbyist.last)
  end

  test "should show lobbyist" do
    get lobbyist_url(@lobbyist)
    assert_response :success
  end

  test "should get edit" do
    get edit_lobbyist_url(@lobbyist)
    assert_response :success
  end

  test "should update lobbyist" do
    patch lobbyist_url(@lobbyist), params: { lobbyist: { description: @lobbyist.description, name: @lobbyist.name } }
    assert_redirected_to lobbyist_url(@lobbyist)
  end

  test "should destroy lobbyist" do
    assert_difference('Lobbyist.count', -1) do
      delete lobbyist_url(@lobbyist)
    end

    assert_redirected_to lobbyists_url
  end
end
