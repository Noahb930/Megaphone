require "application_system_test_case"

class LobbyistsTest < ApplicationSystemTestCase
  setup do
    @lobbyist = lobbyists(:one)
  end

  test "visiting the index" do
    visit lobbyists_url
    assert_selector "h1", text: "Lobbyists"
  end

  test "creating a Lobbyist" do
    visit lobbyists_url
    click_on "New Lobbyist"

    fill_in "Description", with: @lobbyist.description
    fill_in "Name", with: @lobbyist.name
    click_on "Create Lobbyist"

    assert_text "Lobbyist was successfully created"
    click_on "Back"
  end

  test "updating a Lobbyist" do
    visit lobbyists_url
    click_on "Edit", match: :first

    fill_in "Description", with: @lobbyist.description
    fill_in "Name", with: @lobbyist.name
    click_on "Update Lobbyist"

    assert_text "Lobbyist was successfully updated"
    click_on "Back"
  end

  test "destroying a Lobbyist" do
    visit lobbyists_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Lobbyist was successfully destroyed"
  end
end
