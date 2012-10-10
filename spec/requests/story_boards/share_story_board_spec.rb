require 'spec_helper'
 
feature 'share a story board' do
  self.use_transactional_fixtures = false
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @story_board = FactoryGirl.create(:story_board_with_many_slides, :user => @user)
    login(@user)
    visit story_board_path(@story_board)
  end
  
  scenario 'page has share link' do
    page.should have_link('Share')
  end
  
  scenario 'share link should display preview url' do
    find('#share_url .value').text.should eql(preview_story_board_url(@story_board))
  end

end