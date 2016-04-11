require 'spec_helper'

feature 'Admin - Experiences', js: true do

  before do
    country = create(:country, name: "United States")
    create(:state, name: "Vermont", country: country)
    @experience = create :experience
  end

  context 'as an Admin' do

    before do
      login_user create(:admin_user)
      visit spree.admin_path
      within '[data-hook=admin_tabs]' do
        click_link 'Experiences'
      end
      page.should have_content('Listing Experiences')
    end

    scenario 'should be able to create new experience' do
      click_link 'New Experience'
      check 'experience_active'
      fill_in 'experience[name]', with: 'Test Experience'
      fill_in 'experience[email]', with: 'spree@example.com'
      fill_in 'experience[url]', with: 'http://www.test.com'
      fill_in 'experience[commission_flat_rate]', with: '0'
      fill_in 'experience[commission_percentage]', with: '0'
      fill_in 'experience[address_attributes][firstname]', with: 'First'
      fill_in 'experience[address_attributes][lastname]', with: 'Last'
      fill_in 'experience[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'experience[address_attributes][city]', with: 'Test City'
      fill_in 'experience[address_attributes][zipcode]', with: '55555'
      select2 'United States', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'experience[address_attributes][phone]', with: '555-555-5555'
      click_button 'Create'
      page.should have_content('Experience "Test Experience" has been successfully created!')
    end

    scenario 'should be able to delete experience' do
      click_icon 'delete'
      page.driver.browser.switch_to.alert.accept
      within 'table' do
        page.should_not have_content(@experience.name)
      end
    end

    scenario 'should be able to edit experience' do
      click_icon 'edit'
      check 'experience_active'
      fill_in 'experience[name]', with: 'Test Experience'
      fill_in 'experience[email]', with: 'spree@example.com'
      fill_in 'experience[url]', with: 'http://www.test.com'
      fill_in 'experience[commission_flat_rate]', with: '0'
      fill_in 'experience[commission_percentage]', with: '0'
      fill_in 'experience[address_attributes][firstname]', with: 'First'
      fill_in 'experience[address_attributes][lastname]', with: 'Last'
      fill_in 'experience[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'experience[address_attributes][city]', with: 'Test City'
      fill_in 'experience[address_attributes][zipcode]', with: '55555'
      select2 'United States', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'experience[address_attributes][phone]', with: '555-555-5555'
      click_button 'Update'
      page.should have_content('Experience "Test Experience" has been successfully updated!')
    end

  end

  context 'as a Experience' do
    before do
      @user = create(:experience_user)
      login_user @user
      visit spree.edit_admin_experience_path(@user.experience)
    end

    scenario 'should only see tabs they have access to' do
      within '[data-hook=admin_tabs]' do
        page.should_not have_link('Overview')
        page.should have_link('Products')
        page.should_not have_link('Reports')
        page.should_not have_link('Configuration')
        page.should_not have_link('Promotions')
        page.should_not have_link('Experience')
        page.should have_link('Shipments')
      end
    end

    scenario 'should be able to update experience' do
      fill_in 'experience[name]', with: 'Test Experience'
      fill_in 'experience[email]', with: @user.email
      fill_in 'experience[url]', with: 'http://www.test.com'
      fill_in 'experience[address_attributes][firstname]', with: 'First'
      fill_in 'experience[address_attributes][lastname]', with: 'Last'
      fill_in 'experience[address_attributes][address1]', with: '1 Test Drive'
      fill_in 'experience[address_attributes][city]', with: 'Test City'
      fill_in 'experience[address_attributes][zipcode]', with: '55555'
      select2 'United States', from: 'Country'
      select2 'Vermont', from: 'State'
      fill_in 'experience[address_attributes][phone]', with: '555-555-5555'
      page.should_not have_css('#experience_active') # cannot edit active
      page.should_not have_css('#experience_featured') # cannot edit featured
      page.should_not have_css('#s2id_experience_user_ids') # cannot edit assigned users
      page.should_not have_css('#experience_commission_flat_rate') # cannot edit flat rate commission
      page.should_not have_css('#experience_commission_percentage') # cannot edit comission percentage
      click_button 'Update'
      page.should have_content('Experience "Test Experience" has been successfully updated!')
      page.current_path.should eql(spree.edit_admin_experience_path(@user.reload.experience))
    end

  end

  context 'as a User other than the experiences' do

    scenario 'should be unauthorized' do
      experience = create(:experience)
      login_user create(:user)
      visit spree.edit_admin_experience_path(experience)
      page.should have_content('Authorization Failure')
    end

  end

end