require 'rails_helper'
require 'rake'

# references:
# https://gist.github.com/equivalent/5107645
# http://robots.thoughtbot.com/test-rake-tasks-like-a-boss
# http://carlosplusplus.github.io/blog/2014/02/01/testing-rake-tasks-with-rspec/
# http://pivotallabs.com/how-i-test-rake-tasks/
# http://www.philsergi.com/2009/02/testing-rake-tasks-with-rspec.html

describe 'app lib tasks import.rake' do
  let(:agent) { Mechanize.new }
  let(:weather_url) do
    'http://weather2.nmsu.edu/wx-stn-data/network/nmcc/station/nmcc-da-1/request/gdd/et/data/'
  end
  let(:weather_page) { agent.get(weather_url) }
  let(:rake) { Rake::Application.new }
  let(:task_path) { 'lib/tasks/import' }

  before do
    create(:weather_station)
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], '')
    Rake::Task.define_task(:environment)
  end

  it 'loads db/soil_application_unit.csv' do
    Rake::Task['import:soil_application_unit'].invoke
    file = 'db/soil_application_unit.csv'

    CSV.foreach(file, headers: true) do |row|
      unit = SoilApplicationUnit.find_by(name: row['name'])
      row[1] = BigDecimal(row[1]) unless row[1].nil?
      expect(unit.attributes).to include row.to_hash
    end
  end

  it 'updates CurrentEt with Rake task', :slow do
    et_last_week = CurrentEt.find_by(doy: 5.days.ago.yday)
    et_today = CurrentEt.find_by(doy: Time.zone.today.yday)
    et_next_week = CurrentEt.find_by(doy: Time.zone.today.yday)
    et_last_week.update_attributes(fabian_garcia: nil)
    et_today.update_attributes(fabian_garcia: 0.15)
    et_next_week.update_attributes(fabian_garcia: 0.20)
    Rake::Task['import:update_et'].invoke
    et_last_week.reload
    et_today.reload
    et_next_week.reload
    expect(et_last_week.fabian_garcia).not_to be_nil
    expect(et_today.fabian_garcia).to be_nil
    expect(et_next_week.fabian_garcia).to be_nil
  end
end
