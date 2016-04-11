Spree::Product.class_eval do

  has_many :experiences, through: :master

  def add_experience!(experience_or_id)
    experience = experience_or_id.is_a?(Spree::Experience) ? experience_or_id : Spree::Experience.find(experience_or_id)
    populate_for_experience! experience if experience
  end

  def add_experiences!(experience_ids)
    Spree::Experience.where(id: experience_ids).each do |experience|
      populate_for_experience! experience
    end
  end

  # Returns true if the product has a drop shipping experience.
  def experience?
    experiences.present?
  end

  private

  def populate_for_experience!(experience)
    variants_including_master.each do |variant|
      unless variant.experiences.pluck(:id).include?(experience.id)
        variant.experiences << experience
        experience.stock_locations.each { |location| location.propagate_variant(variant) }
      end
    end
  end

end