class LotForm
  include ActiveModel::Model

  attr_reader :lot

  validate :models_are_valid

  delegate :model_name, to: :Lot

  def self.lot_attributes
    Lot.column_names.push(Lot.reflections.keys).flatten
  end

  lot_attributes.each do |attr|
    delegate attr.to_sym, "#{attr}=".to_sym, to: :lot
  end

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

  def models_are_valid
    promote_errors(lot.errors) if lot.invalid?
  end

  def promote_errors(model_errors)
    model_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end
end
