require 'spec_helper'
 
feature 'add slide to a story board' do
  self.use_transactional_fixtures = false
  
  before(:each) do
    @user = FactoryGirl.create(:user)
    @story_board = FactoryGirl.create(:story_board_with_many_slides, :user => @user)
    login(@user)
    visit story_board_path(@story_board)
  end
  
  scenario 'page has add slide link' do
    page.should have_link('Add slide')
  end
  
  scenario 'add slide page has correct fields - javascript', :js => true do
    click_link 'Add slide'
    page.should have_selector('#uploader_container')
    page.should have_button('Save')
  end
  
  scenario 'add slide page has correct fields' do
    within('#story_board_menu') do
      click_button 'Add'
    end
    page.should have_selector('#story_board_attachments_attributes_')
    page.should have_button('Start upload')
  end
  
  scenario 'add slide to beginning' do
    within('#story_board_menu') do
      click_button 'Add'
    end
    attach_file 'story_board_attachments_attributes_', Rails.root + 'spec/fixtures/sample.jpg'
    click_button 'Start upload'
    Delayed::Worker.new.work_off
    
    new_slide = @story_board.slides.where(:order_number => 100).first
    StoryBoard.count.should eql(1)
    @story_board.slides.size.should eql(6)
    # 4/12/12 not yet working with change of processing images in dealyed job
    # find('#left_sidebar .slide-image.current')[:id].should eql("slide-id-#{new_slide.id}")
  end
  
  scenario 'add slide with multi page file' do
    within('#story_board_menu') do
      click_button 'Add'
    end
    attach_file 'story_board_attachments_attributes_', Rails.root + 'spec/fixtures/sample.pdf'
    click_button 'Start upload'
    Delayed::Worker.new.work_off
    
    new_slide = @story_board.slides.where(:order_number => 100).first
    StoryBoard.count.should eql(1)
    @story_board.slides.size.should eql(10)
    # 4/12/12 not yet working with change of processing images in dealyed job
    # find('#left_sidebar .slide-image.current')[:id].should eql("slide-id-#{new_slide.id}")
  end
  
  scenario 'add slide to middle', :js => true do
    second_slide = @story_board.slides.where(:order_number => 200).first
    page.find(:css,"#slide-id-#{second_slide.id} a").click

    click_link 'Add slide'
    attach_file 'story_board_attachments_attributes_', Rails.root + 'spec/fixtures/sample.jpg'
    click_button 'Start upload'
    Delayed::Worker.new.work_off

    new_slide = @story_board.slides.where(:order_number => 300).first
    @story_board.slides.size.should eql(6)
    # 4/12/12 not yet working with change of processing images in dealyed job
    # find('#left_sidebar .slide-image.current')[:id].should eql("slide-id-#{new_slide.id}")
  end

  scenario 'add multiple files' do
    within('#story_board_menu') do
      click_button 'Add'
    end
    attach_file 'story_board_attachments_attributes_', Rails.root + 'spec/fixtures/sample.jpg'
    attach_file 'story_board_attachments_attributes_1_upload', Rails.root + 'spec/fixtures/sample.gif'
    click_button 'Start upload'
    Delayed::Worker.new.work_off
    
    new_slide = @story_board.slides.where(:order_number => 100).first
    StoryBoard.count.should eql(1)
    @story_board.slides.size.should eql(7)
    # 4/12/12 not yet working with change of processing images in dealyed job
    # find('#left_sidebar .slide-image.current')[:id].should eql("slide-id-#{new_slide.id}")
  end
  
  scenario 'cancel' do
    within('#story_board_menu') do
      click_button 'Add'
    end
    click_button 'Cancel'
  end
end