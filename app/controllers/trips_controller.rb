class TripsController < ApplicationController
  def index
    if params[:driver_id]
      @driver = Driver.find_by(id: params[:driver_id])
      if @driver
        @trips = @driver.trips
      else
        head :not_found
        return
      end
    elsif params[:passenger_id]
      @passenger = Passenger.find_by(id: params[:passenger_id])
      if @passenger
        @trips = @passenger.trips
      else
        head :not_found
        return
      end
    else
      @trips = Trip.all
    end
  end

  def show
    @trip = Trip.find_by(id: params[:id])

    unless @trip
      head :not_found
    end
  end

  def new
    if params[:driver_id]
      @driver = Driver.find_by(id: params[:driver_id])
    elsif params[:passenger_id]
      @passenger = Passenger.find_by(id: params[:passenger_id])
    end
    
      @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    successful = @trip.save
    if successful
      redirect_to trips_path
    else
      render :new, status: :bad_request
    end
  end

  private

  def trip_params
    return params.require(:trip).permit(:date, :rating, :cost, :driver_id, :passenger_id)
  end
end
