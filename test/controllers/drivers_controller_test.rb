require "test_helper"

describe DriversController do
  describe "index" do
    it "can get index" do
      # Your code here
    end
  end

  describe "show" do
    # Your tests go here
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
    # Your tests go here
  end

  describe "create" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
