require 'spec_helper'
 
feature 'replace slide image' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @story_board = FactoryGirl.create(:story_board_with_slides_with_items, :user => @user)
    login(@user)
    visit story_board_path(@story_board)
  end
  
  scenario 'existing slide with file having one image' do
    within('#replace_image_dialog') do
      fill_in('slide_id', :with => @story_board.slides.first.id)
      attach_file 'upload', Rails.root + 'spec/fixtures/sample.jpg'
      click_button 'Save'
    end
    @story_board.slides.count.should eql(5)
  end
  
  scenario 'existing slide with file having multiple images' do
    within('#replace_image_dialog') do
      fill_in('slide_id', :with => @story_board.slides.first.id)
      attach_file 'upload', Rails.root + 'spec/fixtures/sample.pdf'
      click_button 'Save'
    end
    @story_board.slides.count.should eql(9)
  end
end