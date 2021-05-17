require "application_system_test_case"

class BookingsTest < ApplicationSystemTestCase
  setup do
    @booking = bookings(:one)
  end

  test "visiting the index" do
    visit bookings_url
    assert_selector "h1", text: "Bookings"
  end

  test "creating a Booking" do
    visit bookings_url
    click_on "New Booking"

    fill_in "Amount", with: @booking.amount
    fill_in "Email", with: @booking.email
    fill_in "Flight", with: @booking.flight_id
    fill_in "Payment token", with: @booking.payment_token
    check "Pmd" if @booking.pmd
    check "Save credit card" if @booking.save_credit_card
    click_on "Create Booking"

    assert_text "Booking was successfully created"
    click_on "Back"
  end

  test "updating a Booking" do
    visit bookings_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @booking.amount
    fill_in "Email", with: @booking.email
    fill_in "Flight", with: @booking.flight_id
    fill_in "Payment token", with: @booking.payment_token
    check "Pmd" if @booking.pmd
    check "Save credit card" if @booking.save_credit_card
    click_on "Update Booking"

    assert_text "Booking was successfully updated"
    click_on "Back"
  end

  test "destroying a Booking" do
    visit bookings_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Booking was successfully destroyed"
  end
end
