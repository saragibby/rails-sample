require 'spec_helper'
 
feature 'story board security level' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @story_board = FactoryGirl.create(:story_board_with_many_slides, :user => @user)
    login(@user)
    visit story_board_path(@story_board)
  end
  
  scenario 'should see security level' do
    page.should have_css('#security_level')
    page.should have_content('Anyone on the Internet can find and access')
  end
  
  scenario 'should be able to change security level' do
    within('#story_board_security_dialog') do
      choose("story_board_security_level_link")
      click_button("Save")
    end
    @story_board.reload
    @story_board.security_level.should eql("link")
  end

end