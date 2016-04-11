Spree.user_class.class_eval do

  belongs_to :experience, class_name: 'Spree::Experience'

  has_many :variants, through: :experience

  def experience?
    experience.present?
  end

end