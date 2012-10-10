require 'spec_helper'

feature "user account" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login(@user)
  end
  
  scenario "has link to account page" do
    page.should have_link("Account")
  end
  
  scenario "access account page" do
    click_link("Account")
    page.should have_content(@user.username)
    page.should have_content(@user.email)
  end

end