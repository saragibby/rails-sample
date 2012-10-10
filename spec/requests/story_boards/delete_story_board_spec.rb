require 'spec_helper'
 
feature 'delete story board' do
  self.use_transactional_fixtures = false
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @story_board = FactoryGirl.create(:story_board_with_slides_with_items, :user => @user)
    login(@user)
    visit story_boards_path()
  end
  
  scenario 'page has delete link' do
    page.should have_link('Delete')
  end
  
  scenario 'delete story board', :js => true do
    click_link 'Delete'
    page.driver.browser.switch_to.alert.dismiss
    page.should have_content(@story_board.title)
    StoryBoard.count.should eql(1)

    click_link 'Delete'
    page.driver.browser.switch_to.alert.accept
    
    page.should_not have_link('Delete')
    page.should_not have_content(@story_board.title)
  end
end
    
