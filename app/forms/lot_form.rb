class LotForm
  include ActiveModel::Model

  attr_reader :lot

  attr_accessor :box_name, :field_name

  validate :models_are_valid

  delegate :model_name, to: :Lot
  delegate :persisted?, to: :lot

  def self.lot_attributes
    Lot.column_names.push(Lot.reflections.keys).flatten
  end

  lot_attributes.each do |attr|
    delegate attr.to_sym, "#{attr}=".to_sym, to: :lot
  end

  def initialize(params = {})
    if params[:id]
      @lot = Lot.find(params[:id])
    else
      @lot = Lot.new(params)
      super(params)
    end
  end

  def self.find(id)
    new(id: id)
  end

  def save
    return false if invalid?
    lot.save
  end

  def update(params)
    lot.assign_attributes(params)
    return false if invalid?
    lot.save
  end

  def find_box_name
    self.box_name = Box.find_by(id: lot.box_id).name
  end

  private

  def models_are_valid
    promote_errors(lot.errors) if lot.invalid?
  end

  def promote_errors(model_errors)
    model_errors.each do |attribute, message|
      errors.add(attribute, message)
      errors.add(:box_name, message) if attribute == :box_id
    end
  end
end
