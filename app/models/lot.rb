class Lot < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }

  belongs_to :box
  belongs_to :freezer_location
  belongs_to :block
  belongs_to :field
  belongs_to :content

  validates :name, presence: true,
                   uniqueness: { scope: :company_id },
                   length: { maximum: 8 }
  validates :full_weight, numericality: { greater_than: 150 }
  validates :company_id, presence: true
  validates :box_id, presence: true
  validates :block_id, presence: true
  validate :location

  def net_weight
    full_weight - (box_weight || 200)
  end

  def move_to(location)
    update(freezer_location_id: location.id)
  end

  def content_name
    if content
      content.name
    else
      ''
    end
  end

  def box_name
    if box
      box.name
    else
      ''
    end
  end

  def location
    location_error unless freezer_location_id.present? ^ shipment_id.present?
  end

  private

  def location_error
    errors.add(:shipment_id, "Lots can not have a shipment
                               and a storage location")
    errors.add(:freezer_location_id, "Lots can not have a shipment
                               and a storage location")
  end

  def box_weight
    box.empty_weight
  end
end
