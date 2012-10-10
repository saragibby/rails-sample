require 'spec_helper'

feature "user is signed out" do
  before(:each) do
    @user = FactoryGirl.create(:user)
    visit "/"
  end
  
  scenario "has sign up form" do
    # TO DO - need to fix now that only admins can sign up new users
    # within('#sign-up') do
    #   page.should have_button('Sign up')
    # end
  end
  
  scenario "has sign in form" do
    within('#sign-in') do
      page.should have_button('Sign in')
    end
  end
  
  scenario 'new user signs up' do
    # TO DO - need to fix now that only admins can sign up new users
    # within("#sign-up") do
    #   fill_in "Email",        :with => "tester@example.com"
    #   fill_in "Username",     :with => "tester"
    #   fill_in "Password",     :with => "password"
    #   fill_in "Confirmation", :with => "password"
    # end
    # click_button "Sign up"
    # page.should have_content("Welcome! You have signed up successfully.")
  end
  
  scenario 'new user attempts to sign up with existing user info' do
    # TO DO - need to fix now that only admins can sign up new users
    # within("#sign-up") do
    #   fill_in "Email",        :with => "bacon@pork.com"
    #   fill_in "Username",     :with => "bacongoodness"
    #   fill_in "Password",     :with => "ilovebacon"
    #   fill_in "Confirmation", :with => "ilovebacon"
    # end
    # click_button "Sign up"
    # page.should have_content("Email has already been taken")
  end
  
  scenario 'existing user signs in' do
    within("#sign-in") do
      fill_in "Email",        :with => "bacon@pork.com"
      fill_in "Password",     :with => "ilovebacon"
    end
    click_button "Sign in"
    page.should have_content("Logged in!")
    current_path.should eql('/story_boards')
  end
  
  scenario 'existing user attempts to sign in with wrong password' do
    within("#sign-in") do
      fill_in "Email",        :with => "bacon@pork.com"
      fill_in "Password",     :with => "wrongpassword"
    end
    click_button "Sign in"
    page.should have_content("Invalid email or password")
    current_path.should eql('/')
  end
end