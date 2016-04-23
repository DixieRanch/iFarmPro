ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/poltergeist'
require 'shoulda/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|

  # Factory Girl shortened syntax; FactoryGirl.create()-> create(), etc.

  config.include FactoryGirl::Syntax::Methods

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with  :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation, 
          { except: %w[ets kcs current_ets weather_stations soil_classes soil_application_units] }
    ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
  end

  config.around(:each) do |test|
    DatabaseCleaner.cleaning do
      test.run
    end
  end

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.tty = true

  # Capybara DSL
  config.include Capybara::DSL
  Capybara.javascript_driver = :poltergeist

  # Rspec config to selectively run tests
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  #Rspec config to skip slow specs by default
  config.filter_run_excluding :slow unless ENV["SLOW_SPECS"]

  # Defer garbage collection
  config.before(:all) { DeferredGarbageCollection.start }
  config.after(:all) { DeferredGarbageCollection.reconsider }

  config.order = 'random'
  
  # Include named routes in specs
  config.include Rails.application.routes.url_helpers
  
  # Needed for #post and #get to work in request specs
  config.infer_spec_type_from_file_location!
end

Capybara.configure do |config|
  #config.exact_options = true
  #config.visible_text_only = true
  config.match = :prefer_exact
  config.ignore_hidden_elements = false
end