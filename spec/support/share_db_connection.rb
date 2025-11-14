# Shared database connection for test performance
# Note: Disabled for JS tests which run in separate processes
# ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection

# Legacy connection handling - disabled to resolve deprecation warning
# module ActiveRecord
#   class Base
#     mattr_accessor :shared_connection
#     @@shared_connection = nil # rubocop:disable Style/ClassVars
#
#     def self.connection
#       @@shared_connection || retrieve_connection
#     end
#   end
# end
