require 'spec_helper'
 
feature 'view story board' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @story_board = FactoryGirl.create(:story_board_with_many_slides, :user => @user)
    login(@user)
    visit story_board_path(@story_board)
  end
  
  scenario 'should have page elements' do
    page.should have_css('#top_menu')
    page.should have_css('#left_sidebar')
    page.should have_css('#site-bottom-nav')
  end
  
  scenario 'should see image for each slide in sidebar' do
    page.should have_css('#left_sidebar .slide-image', :count => 5)
  end
  
  scenario 'slides should be in ascending order_number' do
    first_slide = @story_board.slides.where(:order_number => 0).first
    last_slide = @story_board.slides.where(:order_number => 400).first
    all('#left_sidebar .slide-image').first[:id].should eql("slide-id-#{first_slide.id}")
    all('#left_sidebar .slide-image').last[:id].should eql("slide-id-#{last_slide.id}")
  end
  
  scenario 'first slide should be selected/current' do
    first_slide = @story_board.slides.where(:order_number => 0).first
    find('#left_sidebar .slide-image.current')[:id].should eql("slide-id-#{first_slide.id}")
  end
  
  scenario 'clicking second slide should make it current and load in main' do
    second_slide = @story_board.slides.where(:order_number => 100).first
    page.find("#slide-id-#{second_slide.id} a").click
    find('#left_sidebar .slide-image.current')[:id].should eql("slide-id-#{second_slide.id}")
    find('#canvas')['data-slide_id'].to_i.should eql(second_slide.id)
  end
  
  scenario 'should see select for background in sidebar' do
    page.should have_field('Background')
  end

  scenario 'non-storyboard owners should not be able to access storyboard page' do
    non_owner = FactoryGirl.create(:user, username: 'nonowner', email: 'nonowner@bacon.com')
    click_link 'Logout'
    login(non_owner)
    visit story_board_path(@story_board)
    current_path.should eql('/')
    page.should have_content('Not authorized')
  end

end