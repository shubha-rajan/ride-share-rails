class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  def self.generated_params
    driver = Driver.where(availability: true).sample
    # binding.pry
    params = { date: DateTime.now,
              cost: rand(250...100000) * rand(1..3),
              driver_id: (driver ? driver.id : nil) }
    # binding.pry
    # return params
  end
end
