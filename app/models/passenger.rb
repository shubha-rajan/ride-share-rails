class Passenger < ApplicationRecord
  has_many :trips, dependent: :nullify
  validates :name, presence: true
  validates :phone_num, presence: true

  def total_spent
    trips = self.trips
    total_spent = (trips.reduce(0) { |total, trip| total += trip.cost })
    return total_spent
  end
end
