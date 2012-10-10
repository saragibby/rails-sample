require 'spec_helper'
 
feature 'preview a story board' do
  self.use_transactional_fixtures = false
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @story_board = FactoryGirl.create(:story_board_with_many_slides, :user => @user)
    login(@user)
    visit story_board_path(@story_board)
  end
  
  scenario 'page has preview link' do
    page.should have_link('Preview')
  end
  
  scenario 'preview from story board load (default current slide)', :js => true do
    click_link 'Preview'
    find('#preview')['data-slide_id'].to_i.should eql(@story_board.slides.first.id)
  end

  scenario 'preview from click of different slide', :js => true do
    second_slide = @story_board.slides.where(:order_number => 100).first
    page.find("#slide-id-#{second_slide.id} a").click
    
    click_link 'Preview'
    find('#preview')['data-slide_id'].to_i.should eql(second_slide.id)
  end
  
  scenario 'non-logged in user views preview of public story board' do
    click_link 'Logout'
    visit preview_story_board_path(@story_board)
    page.should have_css('#preview')
  end
  
  scenario 'non-logged in user views preview of private story board - correct password' do
    click_link 'Logout'
    @story_board.update_attributes :security_level => 'private', :password => 'bacon'
    visit preview_story_board_path(@story_board)
    page.should have_content('Please enter password to view')
    fill_in 'story_board_password', :with => 'bacon'
    click_button "View"
    page.should have_css('#preview')
  end
  
  scenario 'non-logged in user views preview of private story board - correct password, navigates to different story board slide' do
    click_link 'Logout'
    @story_board.update_attributes :security_level => 'private', :password => 'bacon'
    visit preview_story_board_path(@story_board)
    fill_in 'story_board_password', :with => 'bacon'
    click_button "View"
    page.should have_css('#preview')
    visit preview_story_board_path(@story_board, :current_slide_id => @story_board.slides[1])
    page.should have_css('#preview')
  end
  
  scenario 'non-logged in user views preview of private story board - incorrect password' do
    click_link 'Logout'
    @story_board.update_attributes :security_level => 'private', :password => 'bacon'
    visit preview_story_board_path(@story_board)
    page.should have_content('Please enter password to view')
    fill_in 'story_board_password', :with => 'wrongpass'
    click_button "View"
    page.should have_content('Password was incorrect')
    page.should have_content('Please enter password to view')
  end

end