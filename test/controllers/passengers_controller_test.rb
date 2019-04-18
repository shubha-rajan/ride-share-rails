require "test_helper"

describe PassengersController do
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
    it "can get index" do
      get passengers_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "returns a 404 status code if the passenger doesn't exist" do
      # TODO come back to this
      passenger_id = 12345

      get passenger_path(passenger_id)

      must_respond_with :not_found
    end

    it "works for a passenger that exists" do
      passenger = Passenger.last

      get passenger_path(passenger.id)

      # Assert
      must_respond_with :ok
    end
  end

  describe "edit" do
    it "can get the edit page for an existing passenger" do

      #Arrange
      passenger = Passenger.last

      # Act
      get edit_passenger_path(passenger.id)

      # Assert
      must_respond_with :success
    end

    it "responds with a 404 for a nonexistent passenger" do
      passenger_id = Passenger.last.id + 1
      get edit_passenger_path(passenger_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    let(:passenger_data) {
      {
        passenger: {
          name: "changed",
          phone_num: "555-5555",
        },
      }
    }
    it "changes information about the passenger" do
      #Arrange
      passenger = Passenger.last

      # Act
      patch passenger_path(passenger.id), params: passenger_data

      # Assert
      must_respond_with :redirect
      must_redirect_to passenger_path(passenger.id)

      passenger.reload
      expect(passenger.name).must_equal(passenger_data[:passenger][:name])
      expect(passenger.phone_num).must_equal(passenger_data[:passenger][:phone_num])
    end
    it "responds with a 404 for a nonexistent passenger" do
      passenger_id = Passenger.last.id + 1
      patch passenger_path(passenger_id), params: passenger_data
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "can get the new passenger page" do
      # Act
      get new_passenger_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new passenger" do
      # Arrange
      passenger_hash = {
        passenger: {
          name: "new passenger",
          phone_num: "0000000000",
        },
      }

      # Act-Assert
      expect {
        post passengers_path, params: passenger_hash
      }.must_change "Passenger.count", 1

      new_passenger = Passenger.find_by(name: passenger_hash[:passenger][:name])

      expect(new_passenger.name).must_equal passenger_hash[:passenger][:name]
      expect(new_passenger.phone_num).must_equal passenger_hash[:passenger][:phone_num]

      must_respond_with :redirect
      must_redirect_to passenger_path(new_passenger.id)
    end
  end

  describe "destroy" do
    # Your tests go here
  end
end
