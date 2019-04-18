class Driver < ApplicationRecord
  has_many :trips, dependent: :nullify

  validates :name, presence: true
  validates :vin, presence: true, length: { is: 17 }

  def total_earnings
    trips = self.trips
    total_earnings = 0.8 * (trips.reduce(0) { |total, trip| total += trip.cost })
    total_earnings -= 165 if ((trips.length > 0) && (total_earnings > 165))
    return total_earnings
  end

  def average_rating
    ratings = self.trips.map { |trip| trip.rating }
    average_rating = (ratings.sum.to_f / ratings.length).round(2)
    return average_rating
  end
end
