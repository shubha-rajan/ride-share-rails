class Driver < ApplicationRecord
  has_many :trips

  validates :name, presence: true
  validates :vin, presence: true, length: {is: 17}

  def total_earnings
    trips = self.trips
    total_earnings = 0.8 * (trips.reduce(0) { |total, trip| total += trip.cost })
    total_earnings -= 165 if ((trips.length > 0) && (total_earnings > 165))
    return total_earnings
  end
end
