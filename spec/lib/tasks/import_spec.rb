require 'rake'

describe 'app lib tasks import.rake' do

  let(:rake) { Rake::Application.new }
  let(:task_path) { 'lib/tasks/import' }

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], '')
    Rake::Task.define_task(:environment)
  end

  # before do
  #   #load File.expand_path('../../../lib/tasks/import.rake', __FILE__)
  #   #load '../../../lib/tasks/import.rake'
  #
  #   @rake = Rake::Application.new
  #   Rake.application = @rake
  #   Rake.application.rake_require 'lib/tasks/import'
  #   #Rake.application.rake_require '../../../lib/tasks/import'
  #   #Rake.application.rake_require File.expand_path('../../../lib/tasks/import', File.dirname(__FILE__))
  #   Rake::Task.define_task(:environment)
  # end
  #
  # it 'stores the weather URL' do
  #   agent = Mechanize.new
  #   agent.get('http://weather.nmsu.edu/ws/data/etform/nmcc-da-1')
  #   expect(agent.page.uri.to_s).to eq 'http://weather.nmsu.edu/ws/data/etform/nmcc-da-1/'
  # end
  #
  # it 'should be a valid weather url' do
  #   pending 'do later'
  # end

  it 'gets rake file' do
    file = Rails.root.join("#{task_path}.rake").to_s
    expect(file).to eq '/home/joe/projects/daviet/ifarm/lib/tasks/import.rake'
  end

end
