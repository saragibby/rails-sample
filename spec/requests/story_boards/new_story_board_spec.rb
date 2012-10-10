require 'spec_helper'
 
feature 'create new story board' do
  self.use_transactional_fixtures = false
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    login(@user)
    visit new_story_board_path
    # StoryBoard.last.update_attributes :dirty => true
  end
  
  scenario 'page should have file upload fields' do
    page.should have_field('story_board_attachments_attributes_')
    page.should have_button('Start upload')
    page.should have_button('Cancel')
  end
  
  scenario 'should have incremented title' do
    story_board = FactoryGirl.create(:story_board, :title => 'Untitled', :user => @user)
    visit new_story_board_path
    page.should have_content('Untitled 1')
    StoryBoard.last.title.should eql('Untitled 1')
  end
  
  scenario 'cancel button should delete story board' do
    click_button 'Cancel'
    StoryBoard.count.should eql(0)
    current_path.should eql('/story_boards')
  end
  
  # scenario 'allow story board creation with no slides' do
  #   click_button 'Save'
  #   Delayed::Worker.new.work_off
  #   
  #   StoryBoard.count.should eql(1)
  #   StoryBoard.last.slides.size.should eql(0)
  #   page.should have_content('No Slides Uploaded')
  # end
  
  scenario 'give user validation message if saving with no files uploaded' do
    click_button 'Start upload'
    page.should have_content('need to be uploaded')
    current_path.should eql("/story_boards/#{StoryBoard.last.id}")
  end
  
  scenario 'upload jpg' do
    attach_file 'story_board_attachments_attributes_', Rails.root + 'spec/fixtures/sample.jpg'
    click_button 'Start upload'
    Delayed::Worker.new.work_off
    
    StoryBoard.count.should eql(1)
    StoryBoard.last.slides.size.should eql(1)
    Slide.last.image_height.should eql(356)
    Slide.last.image_width.should eql(300)
    StoryBoard.last.slides.first.order_number.should eql(0)
  end
  
  scenario 'upload multi-page pdf' do
    attach_file 'story_board_attachments_attributes_', Rails.root + 'spec/fixtures/sample.pdf'
    click_button 'Start upload'
    Delayed::Worker.new.work_off
    
    StoryBoard.count.should eql(1)
    StoryBoard.last.slides.size.should eql(5)
    StoryBoard.last.slides.first.order_number.should eql(0)
    StoryBoard.last.slides.last.order_number.should eql(400)
  end
  
  scenario 'upload gif' do
    attach_file 'story_board_attachments_attributes_', Rails.root + 'spec/fixtures/sample.gif'
    click_button 'Start upload'
    Delayed::Worker.new.work_off
    
    StoryBoard.count.should eql(1)
    StoryBoard.last.slides.size.should eql(1)
  end
  
  scenario 'upload png' do
    attach_file 'story_board_attachments_attributes_', Rails.root + 'spec/fixtures/sample.png'
    click_button 'Start upload'
    Delayed::Worker.new.work_off
    
    StoryBoard.count.should eql(1)
    StoryBoard.last.slides.size.should eql(1)
  end
  
  scenario 'upload multiple files' do
    attach_file 'story_board_attachments_attributes_', Rails.root + 'spec/fixtures/sample.gif'
    attach_file 'story_board_attachments_attributes_1_upload', Rails.root + 'spec/fixtures/sample.png'
    click_button 'Start upload'
    Delayed::Worker.new.work_off
    
    StoryBoard.count.should eql(1)
    StoryBoard.last.slides.size.should eql(2)
  end
  
  # scenario 'upload psd' do
  #   attach_file 'story_board_attachment', Rails.root + 'spec/fixtures/sample.psd'
  #   click_button 'Save'
  #   
  #   worker.run_local
  #   StoryBoard.count.should eql(1)
  #   StoryBoard.last.slides.size.should eql(1)
  # end
  
  # scenario 'upload pptx' do
  #   attach_file 'story_board_attachment', Rails.root + 'spec/fixtures/sample.ppt'
  #   click_button 'Save'
  #   
  #   worker.run_local
  #   StoryBoard.count.should eql(1)
  #   StoryBoard.last.slides.size.should eql(1)
  # end

end