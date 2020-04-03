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
      @lot = Lot.new(params.slice(*Lot.column_names))
      super(params)
    end
  end

  def self.find(id)
    lot_form = new(id: id)
    lot_form.find_box_name
    lot_form.find_field_name
    lot_form
  end

  def save
    lot.box_id = find_box_id_for(box_name)
    lot.field_id = find_field_id_for(field_name, block_id)
    return false if invalid?
    lot.save
  end

  def update(params)
    lot.assign_attributes(params.slice(*Lot.column_names))
    lot.box_id = find_box_id_for(params[:box_name])
    lot.field_id = find_field_id_for(params[:field_name], params[:block_id])
    return false if invalid?
    lot.save
  end

  def find_box_name
    self.box_name = Box.find_by(id: lot.box_id).name
  end

  def find_field_name
    self.field_name = if Field.find_by(id: lot.field_id)
                        Field.find_by(id: lot.field_id).name
                      end
  end

  def find_box_id_for(name)
    Box.find_by(name: name).id if Box.find_by(name: name)
  end

  def find_field_id_for(field, block)
    Field.find_by(name: field, block_id: block).id if
    Field.find_by(name: field, block_id: block)
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
