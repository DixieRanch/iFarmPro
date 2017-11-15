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

  it 'updates CurrentEt with Rake task' do
    create(:weather_station)
    stub_request(:get,  weather_url).to_return(form_file)
    stub_request(:post, weather_url).to_return(response_file)
    CurrentEt.find_by(doy: 176).update_attributes(fabian_garcia: nil)
    CurrentEt.find_by(doy: 182).update_attributes(fabian_garcia: 0.15)
    CurrentEt.find_by(doy: 360).update_attributes(fabian_garcia: 0.20)

    Rake::Task['import:update_et'].invoke

    expect(CurrentEt.find_by(doy: 176).fabian_garcia).not_to be_nil
    expect(CurrentEt.find_by(doy: 182).fabian_garcia).to be_nil
    expect(CurrentEt.find_by(doy: 360).fabian_garcia).to be_nil
  end

  private

  def form_file
    File.new('./spec/fixtures/weather_request_page.html')
  end

  def response_file
    File.new('./spec/fixtures/weather_response_page.html')
  end

  def weather_url
    'http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station/nmcc-da-1/request/gdd/et/data/'
  end
end
