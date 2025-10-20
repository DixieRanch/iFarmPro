require 'rails_helper'
require 'rake'

# references:
# https://gist.github.com/equivalent/5107645
# http://robots.thoughtbot.com/test-rake-tasks-like-a-boss
# http://carlosplusplus.github.io/blog/2014/02/01/testing-rake-tasks-with-rspec/
# http://pivotallabs.com/how-i-test-rake-tasks/
# http://www.philsergi.com/2009/02/testing-rake-tasks-with-rspec.html

describe 'app lib tasks import.rake' do
  before do
    Rake.application.rake_require('lib/tasks/import', [Rails.root.to_s], '')
    Rake::Task.define_task(:environment)
  end

  it 'updates CurrentEt with Rake task', :slow do
    create(:weather_station)
    CurrentEt.find_by(doy: 176).update_attributes(fabian_garcia: nil)
    CurrentEt.find_by(doy: 182).update_attributes(fabian_garcia: 0.15)
    CurrentEt.find_by(doy: 360).update_attributes(fabian_garcia: 0.20)
    
    allow_any_instance_of(Tasks::UpdateEt).to receive(:start_date).and_return('2018-06-25')
    allow_any_instance_of(Tasks::UpdateEt).to receive(:end_date).and_return('2018-06-30')
    
    WebMock.allow_net_connect!
    Tasks::UpdateEt.new.fetch_parse_update_pad_table
    
    expect(CurrentEt.find_by(doy: 176).fabian_garcia).not_to be_nil
    expect(CurrentEt.find_by(doy: 182).fabian_garcia).to be_nil
    expect(CurrentEt.find_by(doy: 360).fabian_garcia).to be_nil
  end
  
  it 'makes a request to check nmsu api', :slow do
    weather_station = create(:weather_station)
    allow_any_instance_of(Tasks::UpdateEt).to receive(:start_date).and_return('2018-01-01')
    allow_any_instance_of(Tasks::UpdateEt).to receive(:end_date).and_return('2018-01-02')

    WebMock.allow_net_connect!
    Tasks::UpdateEt.new.fetch_parse_update_pad_table

    expect(CurrentEt.find_by(doy: 1).fabian_garcia).to eq 0.050
    expect(CurrentEt.find_by(doy: 2).fabian_garcia).to eq 0.070.to_d
  end

  private

  def form_file
    File.new('./spec/fixtures/weather_request_page.html')
  end

  def response_file
    File.new('./spec/fixtures/weather_response_page.html')
  end

  def weather_url
    'https://weather.nmsu.edu/ziamet/request/station//nmcc-da-1/data/daily/gr/'
  end

  def weather_post_url
    'https://weather.nmsu.edu/wx-stn-data/network/nmcc/station/nmcc-da-1/request/gdd/et/data/'
  end
end
