FactoryGirl.define do

  factory :company do
    sequence(:name) { |n| "Company #{n}" }
  end

  factory :weather_station do
    sequence(:name) { |n| "Station #{n}" }
    sequence(:db_col) { |n| "station_#{n}" }
    sequence(:id_code) { |n| "nmcc-da-#{n}" }
  end

  factory :user do
    sequence(:email) { |n| "User_#{n}@Example.com" }
    password "foobar"
    password_confirmation "foobar"
    company
  end

  factory :farm do
    sequence(:name) { |n| "Farm #{n}" }
    weather_station_id 1
  end

  factory :rain do
    date Date.today
    amount 0.75
    farm
  end

  factory :irrigation_well do
    sequence(:name) { |n| "Pump #{n}" }
    sequence(:pod_code) { |n| "lrg-#{12345+n}-pod1" }
    farm
  end

  factory :block do
    sequence(:name) { |n| "Block #{n % 100}" }
    farm
  end

  factory :field do
    sequence(:name) { |n| "Field #{n % 100}" }
    acreage 9.8
    soil_class_id 1
    block
  end

  factory :irrigation do
    time Time.now
    field
  end

  factory :meter_reading do
    sequence(:start) { |n| 112233 + n }
    sequence(:stop) { |n| 223344 + n }
    irrigation
    irrigation_well
  end

  factory :soil_product do
    sequence(:name) { |n| "Product #{n}" }
    n 16
    p 8
    k 3
    s 4
  end

  factory :soil_application do
    date Date.today
    quantity 175
    field
    soil_product
    soil_application_unit_id 2
  end
  
  factory :daily_et do
    date Date.today
    eth  0.27
    weather_station
  end
end