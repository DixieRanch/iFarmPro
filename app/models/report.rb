class Report < ActiveRecord::Base
  # attr_accessible :title, :body

  def self.generate(name)
    Report.send(name)
  end

  def self.next_irrigations
    Irrigation.next_irrigations.sort_by(&:next_irrigation)
  end

  def self.fertilizer
    Field.all.sort_by(&:name_with_block)
  end
  
  def self.next_herbicide_applications
    SoilApplication.next_applications.sort_by(&:next_application)
  end
end
