class PassengersController < ApplicationController
  def index
    @passengers = Passenger.all
  end

  def new
    @passenger = Driver.new
  end

  def create
    @passenger = Passenger.new(passenger_params)

    is_successful = @passenger.save

    if is_successful
      redirect_to passenger_path(@passenger.id)
    else
      render :new
    end
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

    if @passenger
      if @passenger.update passenger_params
        redirect_to passenger_path(@passenger)
      else
        render :edit
      end
    else
      head :not_found
    end
  end

  def destroy
    passenger = Passenger.find_by(id: params[:id])

    unless passenger
      head :not_found
      return
    end

    passenger.destroy

    redirect_to passengers_path
  end

  private

  def passenger_params
    return params.require(:passenger).permit(:name, :phone_num)
  end
end
