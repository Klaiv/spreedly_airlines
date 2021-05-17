require 'test_helper'

class FlightsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @flight = flights(:one)
  end

  test "should get index" do
    get flights_url
    assert_response :success
  end

  test "should get new" do
    get new_flight_url
    assert_response :success
  end

  test "should create flight" do
    assert_difference('Flight.count') do
      post flights_url, params: { flight: { cost: @flight.cost, departure_date: @flight.departure_date, destination_airport: @flight.destination_airport, origin_airport: @flight.origin_airport } }
    end

    assert_redirected_to flight_url(Flight.last)
  end

  test "should show flight" do
    get flight_url(@flight)
    assert_response :success
  end

  test "should get edit" do
    get edit_flight_url(@flight)
    assert_response :success
  end

  test "should update flight" do
    patch flight_url(@flight), params: { flight: { cost: @flight.cost, departure_date: @flight.departure_date, destination_airport: @flight.destination_airport, origin_airport: @flight.origin_airport } }
    assert_redirected_to flight_url(@flight)
  end

  test "should destroy flight" do
    assert_difference('Flight.count', -1) do
      delete flight_url(@flight)
    end

    assert_redirected_to flights_url
  end
end
