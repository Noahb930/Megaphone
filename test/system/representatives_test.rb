require "application_system_test_case"

class RepresentativesTest < ApplicationSystemTestCase
  setup do
    @representative = representatives(:one)
  end

  test "visiting the index" do
    visit representatives_url
    assert_selector "h1", text: "Representatives"
  end

  test "creating a Representative" do
    visit representatives_url
    click_on "New Representative"

    fill_in "District", with: @representative.district
    fill_in "Name", with: @representative.name
    click_on "Create Representative"

    assert_text "Representative was successfully created"
    click_on "Back"
  end

  test "updating a Representative" do
    visit representatives_url
    click_on "Edit", match: :first

    fill_in "District", with: @representative.district
    fill_in "Name", with: @representative.name
    click_on "Update Representative"

    assert_text "Representative was successfully updated"
    click_on "Back"
  end

  test "destroying a Representative" do
    visit representatives_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Representative was successfully destroyed"
  end
end
