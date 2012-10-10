require 'spec_helper'
 
feature 'duplicate story board' do
  before(:each) do
    @user = Factory(:user)
    @story_board = Factory(:story_board_with_slides_with_items, :user => @user)
    login(@user)
    click_link("My Storyboards")
  end
  
  scenario 'link is present' do
    page.should have_link('Create a copy')
  end
  
  scenario 'create copy' do
    click_link('Create a copy')
    StoryBoard.count.should eql(2)
    page.should have_content("#{@story_board.title} 1")
  end
  
end