class LotForm
  include ActiveModel::Model

  def initialize(box = Box.new)
    @box = box
  end

  def find_box_id_for(box_name)
    box_id = (Box.find_by(name: box_name).id if Box.find_by(name: box_name))
    box_id
  end
end
