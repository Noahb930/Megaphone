require "application_system_test_case"

class BillsTest < ApplicationSystemTestCase
  setup do
    @bill = bills(:one)
  end

  test "visiting the index" do
    visit bills_url
    assert_selector "h1", text: "Bills"
  end

  test "creating a Bill" do
    visit bills_url
    click_on "New Bill"

    fill_in "Number", with: @bill.number
    fill_in "Session", with: @bill.session
    fill_in "Shorthand", with: @bill.shorthand
    fill_in "Status", with: @bill.status
    fill_in "Summary", with: @bill.summary
    check "Suppourts gun control" if @bill.suppourts_gun_control
    fill_in "Url", with: @bill.url
    click_on "Create Bill"

    assert_text "Bill was successfully created"
    click_on "Back"
  end

  test "updating a Bill" do
    visit bills_url
    click_on "Edit", match: :first

    fill_in "Number", with: @bill.number
    fill_in "Session", with: @bill.session
    fill_in "Shorthand", with: @bill.shorthand
    fill_in "Status", with: @bill.status
    fill_in "Summary", with: @bill.summary
    check "Suppourts gun control" if @bill.suppourts_gun_control
    fill_in "Url", with: @bill.url
    click_on "Update Bill"

    assert_text "Bill was successfully updated"
    click_on "Back"
  end

  test "destroying a Bill" do
    visit bills_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Bill was successfully destroyed"
  end
end
