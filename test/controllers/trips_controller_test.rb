require "test_helper"

describe TripsController do
  before do
    @passenger = Passenger.create(
      name: "Leroy Jenkins",
      phone_num: "12312312312",
    )

    @driver = Driver.create(
      vin: "111111111111111",
      name: "Tomas",
    )
    @trip = Trip.create(
      date: DateTime.now,
      rating: 4,
      cost: 400.00,
      driver_id: Driver.first.id,
      passenger_id: Passenger.first.id,
    )
  end

  describe "index" do
    it "can render" do
      get trips_path

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
      trip_id = "FAKE_ID"

      get trip_path(trip_id)

      must_respond_with :not_found
    end

    it "works for a trip that exists" do
      get trip_path(@trip.id)

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
        trip: {
          date: Time.now.to_date,
          rating: nil,
          cost: 400.00,
          driver_id: Driver.first.id,
          passenger_id: Passenger.last.id,
        },
      }

      expect {
        post trips_path, params: new_trip
      }.must_change "Trip.count", +1

      must_respond_with :redirect
      must_redirect_to trips_path
    end

    it "sends bad request if the trip isn't successfully made" do
      new_trip = {
        trip: {
          date: "",
        },
      }

      expect(Trip.new(new_trip["trip"])).wont_be :valid?

      expect {
        post trips_path, params: new_trip
      }.wont_change "Trip.count"

      must_respond_with :bad_request
    end
  end

  describe "edit" do
    it "can get the edit page for an existing trip" do
      #Arrange
      trip = Trip.last

      # Act
      get edit_trip_path(trip.id)

      # Assert
      must_respond_with :success
    end

    it "responds with a 404 for a nonexistent trip" do
      trip_id = "FAKE_ID"
      get edit_trip_path(trip_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    it "will change the attributes of an existing trip" do
      test_trip = Trip.last

      trip_hash = {
        trip: {
          date: Time.now.to_date,
          rating: 4,
          cost: 400.00,
          driver_id: Driver.last.id,
          passenger_id: Passenger.first.id,
        },
      }

      expect {
        patch trip_path(test_trip.id), params: trip_hash
      }.wont_change "Trip.count"

      test_trip = Trip.last

      expect(test_trip.date).must_equal trip_hash[:trip][:date]
      expect(test_trip.rating).must_equal trip_hash[:trip][:rating]
      expect(test_trip.cost).must_equal trip_hash[:trip][:cost]
      expect(test_trip.driver_id).must_equal trip_hash[:trip][:driver_id]
      expect(test_trip.passenger_id).must_equal trip_hash[:trip][:passenger_id]
    end
    it "sends bad request if the trip isn't successfully updated" do
      test_trip = Trip.last

      trip_hash = {
        trip: {
          driver_id: "FAKE_ID",
          passenger_id: "FAKE_ID",
        },
      }

      expect(Trip.new(trip_hash["trip"])).wont_be :valid?

      patch trip_path(test_trip.id), params: trip_hash

      must_respond_with :bad_request
    end
  end

  describe "destroy" do
    # Your tests go here
  end
end
