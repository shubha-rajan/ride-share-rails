require "test_helper"

describe DriversController do
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
      get drivers_path

      must_respond_with :success
    end
  end

  describe "show" do
    it "returns a 404 status code if the driver doesn't exist" do
      # TODO come back to this
      driver_id = Driver.last.id + 1

      get driver_path(driver_id)

      must_respond_with :not_found
    end

    it "works for a driver that exists" do
      driver = Driver.last

      get driver_path(driver.id)

      # Assert
      must_respond_with :ok
    end
  end

  describe "edit" do
    it "can get the edit page for an existing driver" do
      #Arrange
      driver = Driver.last

      # Act
      get edit_driver_path(driver.id)

      # Assert
      must_respond_with :success
    end

    it "responds with a 404 for a nonexistent driver" do
      driver_id = Driver.last.id + 1
      get edit_driver_path(driver_id)
      must_respond_with :not_found
    end
  end

  describe "update" do
    let(:driver_data) {
      {
        driver: {
          name: "changed",
          vin: "12345678901234567",
        },
      }
    }
    it "changes information about the driver" do
      #Arrange
      driver = Driver.last

      # Act
      patch driver_path(driver.id), params: driver_data

      # Assert
      must_respond_with :redirect
      must_redirect_to driver_path(driver.id)

      driver.reload

      expect(driver.name).must_equal(driver_data[:driver][:name])
      expect(driver.vin).must_equal(driver_data[:driver][:vin])
    end

    it "responds with a 404 for a nonexistent driver" do
      driver_id = Driver.last.id + 1
      patch driver_path(driver_id), params: driver_data
      must_respond_with :not_found
    end
  end

  describe "new" do
    it "can get the new driver page" do
      # Act
      get new_driver_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new driver" do
      # Arrange
      driver_hash = {
        driver: {
          name: "new driver",
          vin: "12345678901234567",
        },
      }

      # Act-Assert
      expect {
        post drivers_path, params: driver_hash
      }.must_change "Driver.count", 1

      new_driver = Driver.find_by(name: driver_hash[:driver][:name])

      expect(new_driver.name).must_equal driver_hash[:driver][:name]
      expect(new_driver.vin).must_equal driver_hash[:driver][:vin]

      must_respond_with :redirect
      must_redirect_to driver_path(new_driver.id)
    end
  end

  describe "destroy" do
    it "removes the driver from the database" do
      # Act
      expect {
        delete driver_path(@driver)
      }.must_change "Driver.count", -1

      # Assert
      must_respond_with :redirect
      must_redirect_to drivers_path

      deleted_driver = Driver.find_by(id: @driver.id)
      expect(deleted_driver).must_be_nil
    end

    it "sets the foreign keys in associated trips to nil" do
      trips = @driver.trips

      #Assumption
      trips.each do |trip|
        expect(trip.driver).must_equal @driver
      end

      #Act-Assert
      expect {
        delete driver_path(@driver)
      }.wont_change "trips.length"

      trips.each do |trip|
        trip.reload
        expect(trip.driver).must_equal nil
      end
    end

    it "returns a 404 if the driver does not exist" do
      # Arrange
      driver_id = Driver.last.id + 1

      # Assumptions
      expect(Driver.find_by(id: driver_id)).must_be_nil

      # Act
      expect {
        delete driver_path(driver_id)
      }.wont_change "Driver.count"

      # Assert
      must_respond_with :not_found
    end
  end
end
