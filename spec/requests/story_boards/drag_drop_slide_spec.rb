require 'spec_helper'
 
feature 'drag drop slide to change order' do
  self.use_transactional_fixtures = false

  # TODO - Fix into working tests
  # NOTE: Not properly testing drag & drop. Not submit update slide form.
  
  # before(:each) do
  #   @user = Factory(:user)
  #   @story_board = Factory(:story_board_with_many_slides, :user => @user)
  #   login(@user)
  #   visit story_board_path(@story_board)
  # end
  # 
  # scenario 'drag slide higher in list', :js => true do
  #   first_slide = @story_board.slides.first
  #   fourth_slide = @story_board.slides.where(:order_number => 300).first
  #   
  #   first_slide_element = find("#slide-id-#{first_slide.id}")
  #   fourth_slide_element = all('.slide')[3] 
  #   first_slide_element.drag_to(fourth_slide_element)
  # end
  # 
  # scenario 'drag slide lower in list', :js => true do
  #   first_slide = @story_board.slides.first
  #   fourth_slide = @story_board.slides.where(:order_number => 300).first
  #   
  #   first_slide_element = find("#slide-id-#{first_slide.id}")
  #   fourth_slide_element = find("#slide-id-#{fourth_slide.id}") 
  #   
  #   fourth_slide_element.drag_to(first_slide_element)
  # end
end