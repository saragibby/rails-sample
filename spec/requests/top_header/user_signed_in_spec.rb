require 'spec_helper'

feature "user is signed in" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    login(@user)
  end
  
  scenario "shows username" do
    page.should have_content("porky")
  end
  
  scenario "has logout link" do
    page.should have_link('Logout')
  end
  
  scenario "has link to user's storyboards" do
    page.should have_link('My Storyboards')
  end
  
  scenario "has link to user's account" do
    page.should have_link('Account')
  end
  
  scenario "user logs out" do
    click_link 'Logout'
    page.should have_button('Sign in')
  end
end