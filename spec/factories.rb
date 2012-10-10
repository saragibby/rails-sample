FactoryGirl.define do
  factory :user do
    username  'porky'
    email     'bacon@pork.com'
    password  'ilovebacon'
  end
  
  factory :story_board do
    association :user, :factory => :user
    title       "MyString"
    dirty       false
  end
  
  factory :story_board_attachment do
    association :story_board, :factory => :story_board
    attachment  { fixture_file_upload('/sample.jpg', 'image/jpg') }
    processed   false
  end
  
  factory :slide do
    association   :story_board, :factory => :story_board
    image         { fixture_file_upload('/sample.jpg', 'image/jpg') }
    order_number  0
    image_height  800
    image_width   1024
  end
  
  factory :action_item do
    slide nil
    action_type "text"
    top 1
    left 1
    width 1
    height 1
  end
  
  factory :story_board_with_slide, :parent => :story_board do
    after_create { |a| FactoryGirl.create(:slide, :story_board => a) }
  end
  
  factory :story_board_with_many_slides, :parent => :story_board do
    after_create do |a| 
      (0..4).each{ |i| FactoryGirl.create(:slide, :story_board => a, :order_number => i*100) }
    end
  end
  
  factory :story_board_with_slides_with_items, :parent => :story_board do
    after_create do |a| 
      (0..4).each{ |i| FactoryGirl.create(:slide_with_many_action_items, :story_board => a, :order_number => i*100) }
    end
  end
  
  factory :slide_with_many_action_items, :parent => :slide do
    after_create do |a| 
      (0..3).each{ |i| FactoryGirl.create(:action_item, :slide => a) }
    end
  end
  
  factory :slide_with_broken_internal_link, :parent => :slide do
    after_create { |a| FactoryGirl.create(:action_item, :slide => a, :action_type => "link", :data => {"link_type"=>"internal", "internal_link"=>"", "external_link"=>""}) }
  end
  
  factory :action_item_with_internal_link, :parent => :action_item do
    action_type "link"
    data        ({"link_type"=>"internal", "internal_link"=>"123", "external_link"=>""})
    association :slide, :factory => :slide
  end
  
  factory :action_item_with_broken_internal_link, :parent => :action_item do
    action_type "link"
    data        ({"link_type"=>"internal", "internal_link"=>"", "external_link"=>""})
    association :slide, :factory => :slide
  end
  
end