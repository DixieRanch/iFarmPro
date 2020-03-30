class Lot < ActiveRecord::Base
  default_scope { where(company_id: Company.current_id) }

  belongs_to :box
  belongs_to :freezer_location
  belongs_to :block
  belongs_to :field
  belongs_to :content

  attr_writer :box_name
  attr_accessor :field_name

  validates :name, presence: true,
                   uniqueness: { scope: :company_id },
                   length: { maximum: 8 }
  validates :full_weight, numericality: { greater_than: 150 }
  validates :company_id, presence: true
  validates :box_id, presence: true
  validates :freezer_location_id, presence: true
  validates :block_id, presence: true
  validate :box_name_has_error
  validate :field_name_has_error

  def net_weight
    full_weight - box_weight
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

  private

  def box_weight
    box.empty_weight
  end

  def box_name_has_error
    errors.add(:box_name, errors[:box_id]) if errors[:box_id]
  end

  def field_name_has_error
    errors.add(:field_name, errors[:field_id]) if errors[:field_id]
  end
end
