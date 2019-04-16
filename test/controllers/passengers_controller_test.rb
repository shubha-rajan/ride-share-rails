require "test_helper"

describe PassengersController do
  describe "index" do
    # Your tests go here
  end

  describe "show" do
    # Your tests go here
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
    # Your tests go here
  end

  describe "create" do
    # Your tests go here
  end

  describe "destroy" do
    # Your tests go here
  end
end
