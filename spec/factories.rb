FactoryGirl.define do
  factory :company do
    sequence(:name) { |n| "Company #{n}" }
  end

  factory :website do
    name       'NMSU'
    url        'http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station/'
    url_suffix '/request/gdd/et/data/'
    initialize_with { Website.find_or_create_by name: name }
  end

  factory :weather_station do
    name    'Fabian Garcia'
    db_col  'fabian_garcia'
    id_code 'nmcc-da-1'
    website
    initialize_with { WeatherStation.find_or_create_by name: name }
  end

  factory :user do
    sequence(:email) { |n| "User_#{n}@Example.com" }
    password 'foobar'
    password_confirmation { password }
    activated true
    company
  end

  factory :farm do
    sequence(:name) { |n| "Farm #{n}" }
    weather_station
  end

  factory :rain do
    date Time.zone.today
    amount 0.75
    farm
  end

  factory :irrigation_well do
    sequence(:name) { |n| "Pump #{n}" }
    sequence(:pod_code) { |n| "lrg-#{12345 + n}-pod1" }
    farm
  end

  factory :block do
    sequence(:name) { |n| "Block #{n % 100}" }
    farm
  end

  factory :field do
    sequence(:name) { |n| "Field #{n % 100}" }
    acreage 9.8
    soil_class
    block
  end

  factory :irrigation do
    time Time.zone.now
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
    date Time.zone.today
    quantity 175
    field
    soil_product
    soil_application_unit
  end

  factory :daily_et do
    date Time.zone.today
    eth  0.27
    weather_station
  end

  factory :average_et do
    doy 175
    eth 0.37
    weather_station
  end

  factory :soil_class do
    name 'Sandy Loam'
    aw 8.4
    initialize_with { SoilClass.find_or_create_by name: name }
  end

  factory :soil_application_unit do
    name 'Gal'
    density 11
    initialize_with { SoilApplicationUnit.find_or_create_by name: name }
  end

  factory :freezer_location do
    sequence(:name) { |n| "A-#{n}" }
    farm
  end

  factory :box do
    sequence(:name) { |n| "Box #{n}" }
  end

  factory :lot do
    name '2018-001'
    full_weight 2000
    box_id 1
    freezer_location_id 1
    block_id 1
  end

  factory :shipment do
    name '2018-001'
    date Time.zone.today
    destination 'Sheller'
  end
end
