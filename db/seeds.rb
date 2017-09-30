# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Rake::Task["import:et"].invoke
Rake::Task["import:kc"].invoke
Rake::Task["import:current_et"].invoke
Rake::Task["import:soil_class"].invoke
Rake::Task["import:initial_weather_station"].invoke
Rake::Task["import:soil_application_unit"].invoke
