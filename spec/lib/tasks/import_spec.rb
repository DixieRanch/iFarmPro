require 'spec_helper'
require 'rake'

# references:
# https://gist.github.com/equivalent/5107645
# http://robots.thoughtbot.com/test-rake-tasks-like-a-boss
# http://carlosplusplus.github.io/blog/2014/02/01/testing-rake-tasks-with-rspec/
# http://pivotallabs.com/how-i-test-rake-tasks/
# http://www.philsergi.com/2009/02/testing-rake-tasks-with-rspec.html

describe 'app lib tasks import.rake' do

  let(:rake) { Rake::Application.new }
  let(:task_path) { 'lib/tasks/import' }
  let(:agent) { Mechanize.new }
  let(:weather_url) { 'http://weather.nmsu.edu/ws/data/etform/nmcc-da-1' }

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], '')
    Rake::Task.define_task(:environment)
  end

  it 'validates weather URL' do
    agent.get(weather_url)
    expect(agent.page.uri.to_s).to eq 'http://weather.nmsu.edu/ws/data/etform/nmcc-da-1/'
  end

  it 'should execute test_task' do
    Rake::Task['import:test_task'].invoke
  end

end
