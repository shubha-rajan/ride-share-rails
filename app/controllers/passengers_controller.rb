class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all
  end

  def show
    @passenger = Passenger.find_by(id: params[:id])
    unless @passenger
      head :not_found
    end
  end

  def edit
    @passenger = Passenger.find_by(id: params[:id])
    unless @passenger
      head :not_found
    end
  end

  def update
    @passenger = Passenger.find_by(id: params[:id])

    if passenger
      if @passenger.update passenger_params
        redirect_to passenger_path(passenger_id)
      else
        render new
      end
    else
      head :not_found
    end
  end

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
