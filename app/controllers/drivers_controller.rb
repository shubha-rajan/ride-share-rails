class DriversController < ApplicationController
  def index
    @drivers = Driver.all
  end

  def new
      @driver = Driver.new
  end

  def create 
    @driver = Driver.new(driver_params)

    is_successful = @driver.save

    if is_successful
      redirect_to driver_path(driver.id)
    else
      head :not_found
    end
  end

  def show
    @driver = Driver.find_by(id: params[:id])

    unless @driver
      head :not_found
    end
  end

  def edit
    @driver = Driver.find_by(id: params[:id])
    unless @driver
      head :not_found
    end
  end

  def update
    @driver = Driver.find_by(id: params[:id])

    if @driver
      if @driver.update driver_params
        redirect_to driver_path(@driver)
      else
        render new
      end
    else
      head :not_found
    end
  end

  private

  def driver_params
    return params.require(:driver).permit(:name, :vin)
  end
end
