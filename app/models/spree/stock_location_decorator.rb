Spree::StockLocation.class_eval do

  belongs_to :experience, class_name: 'Spree::experience'

  scope :by_experience, -> (experience_id) { where(experience_id: experience_id) }

  # Wrapper for creating a new stock item respecting the backorderable config and experience
  durably_decorate :propagate_variant, mode: 'soft', sha: 'f35b0d8a811311d4886d53024a9aa34e3aa5f8cb' do |variant|
    if self.experience_id.blank? || variant.experiences.pluck(:id).include?(self.experience_id)
      self.stock_items.create!(variant: variant, backorderable: self.backorderable_default)
    end
  end

  def available?(variant)
    stock_item(variant).try(:available?)
  end

end