source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails',                   '~> 4.1.1'
gem 'bcrypt-ruby',             '~> 3.1.5'
gem 'faker',                   '~> 1.3.0'
gem 'will_paginate',           '~> 3.0.3'
gem 'bootstrap-will_paginate', '~> 0.0.6'
gem 'jquery-rails',            '~> 3.1.0'
gem 'american_date',           '~> 1.1.0'
gem 'mechanize',               '~> 2.7.2'
gem 'pg',                      '~> 0.17.1'
gem 'simple_form',             '~> 3.0.2'
gem 'sprockets',               '2.11.0'

# Gems for transition to rails 4

gem 'protected_attributes'
gem 'rails-observers'
gem 'actionpack-page_caching'
gem 'actionpack-action_caching'
gem 'activerecord-deprecated_finders'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'rspec-rails'#,        '2.14.2'
  gem 'guard-rspec'#,        '2.5.0'
  gem 'guard-spork',        '1.5.0'
  gem 'spork-rails',        '4.0.0'  
  # gem 'spork'#,              '0.9.2'
  gem 'annotate'#,           '2.5.0'
  gem 'launchy'
end

# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails'#,         '~> 3.2.5'
gem 'coffee-rails'#,       '~> 3.2.2'
gem 'uglifier'#,           '~> 1.2.3'
gem 'sass'#,               '~> 3.2.13'
gem 'bootstrap-sass'#,     '~> 3.1.1'


group :test do
  gem 'capybara'#,           '~> 2.1.0'
  gem 'rb-inotify'#,         '~> 0.9'
  gem 'libnotify'#,          '~> 0.7.4'
  gem 'factory_girl_rails'#, '~> 4.1.0'
  gem 'shoulda-matchers',   '~> 2.6.0', require: false
  gem 'poltergeist'#,        '~> 1.5.0'
  gem 'database_cleaner'#,   '~> 1.2.0'
end