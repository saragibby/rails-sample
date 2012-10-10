require 'spec_helper'
 
feature 'user story boards' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @story_board = FactoryGirl.create(:story_board_with_slide, :user => @user)
    login(@user)
    click_link("My Storyboards")
  end
  
  scenario 'displays list of story boards' do
    page.should have_table('my_story_boards')
  end
  
  scenario 'link to create new storyboard' do
    page.should have_link('New Storyboard')
  end
  
  scenario 'create new storyboard' do
    click_link('New Storyboard')
    page.should have_content('Untitled')
    page.should have_content('Upload Images')
  end
  
  scenario 'storyboard as action links' do 
    within('table#my_story_boards tbody tr') do
      page.should have_link("Delete")
      page.should have_link("Create a copy")
    end
  end
  
  scenario 'link to existing story board' do
    within('table#my_story_boards tbody tr') do
      click_link(@story_board.title)
    end
    page.should have_content(@story_board.title)
    current_path.should eql(story_board_path(@story_board))
  end
end