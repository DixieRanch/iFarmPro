class LotForm
  include ActiveModel::Model

  attr_accessor(
    :name,
    :full_weight,
    :box_id,
    :freezer_location_id,
    :block_id,
    :field_id,
    :content_id
  )

  attr_reader :lot

  validate :lot_is_valid

  delegate :model_name, to: :Lot

  def initialize(params = {})
    @lot = Lot.new(params)
    super(params)
  end

  def submit
  end

  def save
    return false if invalid?
    lot.save
  end

  private

  def lot_is_valid
    promote_errors(lot.errors) if lot.invalid?
  end

  def promote_errors(model_errors)
    model_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
