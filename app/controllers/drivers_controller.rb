class DriversController < ApplicationController
  def index
    @drivers = Driver.all
  end

  def show
    @driver = Driver.find_by(id: params[:id])
  end

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin)
  end
end
