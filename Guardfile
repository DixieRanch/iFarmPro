# A sample Guardfile
# More info at https://github.com/guard/guard#readme
require 'active_support'
require 'active_support/core_ext'

notification :off

scope group: :fast

group :fast do
  guard :rspec, cmd: 'spring rspec --tag ~slow', all_after_pass: false, failed_mode: :keep do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }
  
    # Rails example
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
      ["spec/routing/#{m[1]}_routing_spec.rb",
       "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
       "spec/acceptance/#{m[1]}_spec.rb"]
    end
    watch(%r{^spec/support/(.+)\.rb$})  { "spec" }
    watch('spec/spec_helper.rb')        { "spec" }
    watch('config/routes.rb')           { "spec/routing" }
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
      ["spec/routing/#{m[1]}_routing_spec.rb",
       "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
       "spec/acceptance/#{m[1]}_spec.rb",
       "spec/requests/#{m[1]}_spec.rb", 
       "spec/requests/#{m[1].singularize}_spec.rb", 
       "spec/requests/#{m[1].singularize}_pages_spec.rb"]
    end
    watch(%r{^app/views/(.+)/}) do |m|
      ["spec/requests/#{m[1]}_spec.rb", 
       "spec/requests/#{m[1].singularize}_spec.rb", 
       "spec/requests/#{m[1].singularize}_pages_spec.rb"]
    end
    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) do |m|
      ["spec/requests/#{m[1]}_spec.rb" ]
    end
  end
end

group :slow do
  guard :rspec, cmd: 'spring rspec', all_after_pass: false, failed_mode: :keep do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }
  
    # Rails example
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
      ["spec/routing/#{m[1]}_routing_spec.rb",
       "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
       "spec/acceptance/#{m[1]}_spec.rb"]
    end
    watch(%r{^spec/support/(.+)\.rb$})  { "spec" }
    watch('spec/spec_helper.rb')        { "spec" }
    watch('config/routes.rb')           { "spec/routing" }
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
      ["spec/routing/#{m[1]}_routing_spec.rb",
       "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
       "spec/acceptance/#{m[1]}_spec.rb",
       (m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" : 
                         "spec/requests/#{m[1].singularize}_pages_spec.rb")]
    end
    watch(%r{^app/views/(.+)/}) do |m|
      (m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" : 
                         "spec/requests/#{m[1].singularize}_pages_spec.rb")
    end
    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$}) do |m|
      ["spec/requests/#{m[1]}_spec.rb" ]
    end
  end
end