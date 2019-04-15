class TripsController < ApplicationController
  def index
    @trips = Trip.all
  end


private
  def trip_params
    return params.require(:trip).permit(:date, :rating, :cost, :driver_id, :passenger_id)
  end
end
