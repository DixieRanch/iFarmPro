# == Schema Information
#
# Table name: current_ets
#
#  id            :integer          not null, primary key
#  doy           :integer
#  fabian_garcia :decimal(, )
#  created_at    :datetime
#  updated_at    :datetime
#

class CurrentEt < ActiveRecord::Base
  validates :fabian_garcia, numericality: { greater_than: 0.0,
                                            allow_nil: true }
end
