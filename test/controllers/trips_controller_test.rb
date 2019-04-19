require "test_helper"

describe TripsController do
  before do
    @passenger = Passenger.create(
      name: "Leroy Jenkins",
      phone_num: "12312312312",
    )

    @driver = Driver.create(
      vin: "12345678901234567",
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
    it "can render a passenger's trips" do
      get passenger_trips_path(@passenger.id)
      must_respond_with :ok
    end

    it "can render a driver's trips" do
      get driver_trips_path(@driver.id)
      must_respond_with :ok
    end

    it "renders passenger trips even if there are no trips" do
      Trip.destroy_all

      get passenger_trips_path(@passenger.id)

      must_respond_with :ok
    end

    it "renders driver trips even if there are no trips" do
      Trip.destroy_all

      get driver_trips_path(@driver.id)

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

  describe "create" do
    it "creates a new trip" do
      expect {
        post passenger_trips_path(Passenger.last.id)
      }.must_change "Trip.count", +1

      must_respond_with :redirect
      must_redirect_to trip_path(Trip.last.id)
    end

    it "sends bad request if the trip isn't successfully made" do
      Driver.all.each do |driver|
        driver.availability = false
        driver.save
        # binding.pry
      end

      expect {
        post passenger_trips_path(Passenger.last.id)
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
    it "removes the trip from the database" do
      # Act
      expect {
        delete trip_path(@trip)
      }.must_change "Trip.count", -1

      # Assert
      must_respond_with :redirect
      must_redirect_to trips_path

      deleted_trip = Trip.find_by(id: @trip.id)
      expect(deleted_trip).must_be_nil
    end

    it "returns a 404 if the trip does not exist" do
      # Arrange
      trip_id = 12345678900000

      # Assumptions
      expect(Trip.find_by(id: trip_id)).must_be_nil

      # Act
      expect {
        delete passenger_path(trip_id)
      }.wont_change "Trip.count"

      # Assert
      must_respond_with :not_found
    end
  end

  describe "add_rating" do
    before do
      @test_params = {
        trip: {
          rating: 4,
        },
      }
    end

    it "changes the rating of an unrated trip" do
      #Arrange
      @trip.rating = nil
      @trip.save

      #Act
      post add_rating_trip_path(@trip.id), params: @test_params
      @trip.reload

      #Assert
      expect(@trip.rating).must_equal @test_params[:trip][:rating]
    end

    it "returns a 404 if the trip does not exist" do
      # Arrange
      trip_id = 12345678900000

      # Assumptions
      expect(Trip.find_by(id: trip_id)).must_be_nil

      # Act
      post add_rating_trip_path(trip_id), params: @test_params

      # Assert
      must_respond_with :not_found
    end
  end
end
