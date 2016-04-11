require 'spec_helper'

describe 'Admin - Products', js: true do

  context 'as Admin' do

    xit 'should be able to change experience' do
      s1 = create(:experience)
      s2 = create(:experience)
      product = create :product
      product.add_experience! s1

      login_user create(:admin_user)
      visit spree.admin_product_path(product)

      select2 s2.name, from: 'Experience'
      click_button 'Update'

      expect(page).to have_content("Product \"#{product.name}\" has been successfully updated!")
      expect(product.reload.experiences.first.id).to eql(s2.id)
    end

  end

end