class PassengersController < ApplicationController
  def index
    @passengers= Passenger.all
  end

private
def passenger_params
  return params.require(:passenger).permit(:name, :phone_num)
end
end
