require 'spec_helper'

feature "user change password" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login(@user)
    click_link("Account")
  end
  
  scenario "has link to change password" do
    page.should have_link("Change password")
  end
  
  scenario "change password - matching old password" do
    click_link "Change password"
    
    fill_in 'old_password', :with => 'ilovebacon'
    fill_in 'password', :with => 'ymmBacon'
    fill_in 'password_confirmation', :with => 'ymmBacon'
    click_button "Change password"
    
    page.should have_content("My Account")
    page.should have_content("Password successfully updated")
  end
  
  scenario "change password - non matching old password" do
    click_link "Change password"
    
    fill_in 'old_password', :with => 'wrongpass'
    fill_in 'password', :with => 'ymmBacon'
    fill_in 'password_confirmation', :with => 'ymmBacon'
    click_button "Change password"
    
    page.should have_content("Change Password")
    page.should have_content("Old password incorrect")
  end
  
  scenario "change password - non matching new password" do
    click_link "Change password"
    
    fill_in 'old_password', :with => 'ilovebacon'
    fill_in 'password', :with => 'ymmBacon'
    fill_in 'password_confirmation', :with => 'ymmBacon1'
    click_button "Change password"
    
    page.should have_content("Change Password")
    page.should have_content("New Password mismatch")
  end
  
  scenario "change password, log out, log in with new password" do
    click_link "Change password"
    fill_in 'old_password', :with => 'ilovebacon'
    fill_in 'password', :with => 'ymmBacon'
    fill_in 'password_confirmation', :with => 'ymmBacon'
    click_button "Change password"
    
    click_link 'Logout'
    within("#sign-in") do
      fill_in "Email",        :with => "bacon@pork.com"
      fill_in "Password",     :with => "ymmBacon"
    end
    click_button "Sign in"
    page.should have_content("Logged in!")
    current_path.should eql('/story_boards')
  end

end