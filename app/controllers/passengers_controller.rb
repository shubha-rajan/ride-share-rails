class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all
  end

  def show
    @passenger = Passenger.find_by(id: params[:id])
  end

private
def passenger_params
  return params.require(:passenger).permit(:name, :phone_num)
end
end
