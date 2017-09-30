# == Schema Information
#
# Table name: weather_stations
#
#  id         :integer          not null, primary key
#  name       :string
#  id_code    :string
#  db_col     :string
#  created_at :datetime
#  updated_at :datetime
#  website_id :integer
#

class WeatherStation < ActiveRecord::Base
  belongs_to :website
  has_many :farms
  has_many :daily_ets
  has_many :average_ets

  validates :name,       presence: true, uniqueness: { case_sensitive: false }
  validates :db_col,     presence: true
  validates :id_code,    presence: true, uniqueness: { scope: :website_id }
  validates :website_id, presence: true

  def update_daily_et
    # Add WeatherStation's DailyEts for the previous 30 days

    store(parse(fetch(30.days.ago.to_date, 1.day.ago.to_date)))
  end

  def url
    # build url for weather station data request page

    if website.url_suffix
      website.url + id_code + website.url_suffix
    else
      website.url + id_code
    end
  end

  def fetch(start_date, end_date)
    # Get webpage with data for DailyEts

    # get et request form
    agent = Mechanize.new
    agent.get url

    # edit start and end date
    agent.page.forms[0]['start_date'] = start_date
    agent.page.forms[0]['end_date'] = end_date

    # submit
    agent.page.forms[0].submit
  end

  def parse(page)
    # create an array of hashes containing et data from webpage

    array = []
    page.search('table')[0].search('tbody').search('tr').each do |row|
      array << { date: row.search('td')[0].text.to_date,
                 eth:  row.search('td')[10].text.to_f }
    end
    array
  end

  def store(array)
    # store data from array of et hashes to DailyEts

    array.each do |row|
      et = daily_ets.find_or_initialize_by(date: row[:date])
      et.eth = row[:eth]
      et.save
    end
  end

  def update_average_et
    # Update the AverageEts for a weather station

    doy_average_et_hash.each do |doy, eth|
      average_ets.find_or_create_by(doy: doy).update_attributes(eth: eth)
    end
  end

  def doy_average_et_hash
    # Create a hash of average ETH for each day of the year

    query = DailyEt.group("EXTRACT(DOY FROM date)").average(:eth)
    et_hash = Hash.new
    query.each_pair { |doy, eth| et_hash.store(doy.to_i, eth.to_f) }
    et_hash
  end

  def load_history
    # Add 20 years of past et data for weatherstation

    n = 0
    begin
      start_date = (n + 1).years.ago.to_date
      end_date   = n.years.ago.to_date.-1
      et_array = parse(fetch(start_date, end_date))
      store(et_array)
      n += 1
    end while !et_array.empty? and n < 20
  end
end
