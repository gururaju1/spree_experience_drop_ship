module Spree
  Variant.class_eval do

    has_many :experiences, through: :experience_variants
    has_many :experience_variants

    before_create :populate_for_experiences

    private

    durably_decorate :create_stock_items, mode: 'soft', sha: '98704433ac5c66ba46e02699f3cf03d13d4f1281' do
      StockLocation.all.each do |stock_location|
        if stock_location.experience_id.blank? || self.experiences.pluck(:id).include?(stock_location.experience_id)
          stock_location.propagate_variant(self) if stock_location.propagate_all_variants?
        end
      end
    end

    def populate_for_experiences
      self.experiences = self.product.experiences
    end

  end
end