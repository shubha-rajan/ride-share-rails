class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  def self.generated_params
    return { date: DateTime.now,
            cost: rand(250...100000) * rand(1..3),
            driver_id: (Driver.where(availability: true)).sample.id }
  end
end
