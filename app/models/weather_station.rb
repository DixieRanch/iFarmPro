# == Schema Information
#
# Table name: weather_stations
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  id_code    :string(255)
#  db_col     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class WeatherStation < ActiveRecord::Base

  belongs_to :website
  has_many :farms
  has_many :daily_ets
  has_many :average_ets

  validates :name,       presence: true
  validates :db_col,     presence: true
  validates :id_code,    presence: true
  validates :website_id, presence: true
  
  def update_daily_et
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
    # create an array containing data from webpage
    array = []
    page.search('table')[0].search('tbody').search('tr').each do |row|
        array << {date: row.search('td')[0].text.to_date, 
                  eth:  row.search('td')[10].text.to_f}
    end
    array
  end
  
  def store(array)
    # store array data to DailyEts
    array.each do |row|
      et = daily_ets.find_or_initialize_by(date: row[:date])
      et.eth = row[:eth]
      et.save
    end
  end
  
  def update_average_et
    doy_average_et_hash.each do |doy, eth|
      average_ets.find_or_create_by(doy: doy).update_attributes(eth: eth)
    end
  end
  
  def doy_average_et_hash
    query = DailyEt.group("EXTRACT(DOY FROM date)").average(:eth)
    et_hash = Hash.new
    query.each_pair{ |doy, eth| et_hash.store(doy.to_i, eth.to_f) }
    et_hash
  end
  
  
end