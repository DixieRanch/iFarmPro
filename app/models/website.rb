# == Schema Information
#
# Table name: websites
#
#  id         :integer          not null, primary key
#  name       :string
#  url        :string
#  url_suffix :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Website < ActiveRecord::Base
  has_many :weather_stations

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :url,  presence: true, uniqueness: { case_sensitive: false,
                                                 scope: :url_suffix }
end
