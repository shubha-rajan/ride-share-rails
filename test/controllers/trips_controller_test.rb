require "test_helper"

describe TripsController do
  describe "index" do
    it "can render" do
      get tasks_path

      must_respond_with :ok
    end

    it "renders even if there are no trips" do
      Trip.destroy_all

      get trips_path

      must_respond_with :ok
    end
  end

  describe "show" do
    it "returns a 404 status code if the trip doesn't exist" do
      # TODO come back to this
      trip_id = 12345

      get trip_path(trip_id)

      must_respond_with :not_found
    end

    it "works for a trip that exists" do
      get book_path(@trip.id)

      must_respond_with :ok
    end
  end

  describe "new" do
    it "retruns status code 200" do
      get new_trip_path
      must_respond_with :ok
    end
  end

  describe "create" do
    it "creates a new trip" do
      new_trip = { 
        date: DateTime.now, 
        rating: 4,
        cost: 400.00,
        driver_id: 1, 
        passenger_id: 1
      }

      expect {
        post trips_path, params: new_trip
      }.must_change "Trip.count", +1

      must_respond_with :redirect
      must_redirect_to trips_path
    end

    it "sends bad request if the trip isn't successfully made" do
      new_trip = {
        date: ""
      }

      expect(Trip.new(new_trip)).wont_be :valid?

      expect {
        post trips_path, params: new_trip
      }.wont_change "Trip.count"

      must_respond_with :bad_request

    end
  end

  describe "edit" do
    # Your tests go here
  end

  describe "update" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
