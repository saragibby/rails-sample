class Slide < ActiveRecord::Base
  include Shared::AttachmentHelper
  include Shared::SlideCreator
  
  belongs_to :story_board
  belongs_to :story_board_attachment
  has_many :action_items, :dependent => :destroy
  
  has_attachment :image,  { :path => "/story_boards/:story_board_id/slides/:id/:style.:extension",
                            :styles => { :small => "130x100#", :thumb => "54x33#", :web => "1280>" },
                            :convert_options => { :small => "-quality 70", :thumb => "-quality 70", :web => "-quality 95" }
                          }
    
  after_post_process :save_image_dimensions
  
  def save_image_dimensions
    geo = Paperclip::Geometry.from_file(image.queued_for_write[:web])
    self.image_width = geo.width.to_i
    self.image_height = geo.height.to_i
  end
  
  def duplicate(story_board)
    dup_slide = Slide.create( :story_board => story_board, :image => self.image, :title => self.title,
                              :order_number => self.order_number)
    self.action_items.each{ |action_item| action_item.duplicate(dup_slide) }
    dup_slide
  end
  
  def has_internal_link_action_item?
    internal_link_action_items.size > 0
  end
  
  def internal_link_action_items
    self.action_items.links.reject{|l| l.data.nil?}.select{|a| a.data["internal_link"].present? }
  end
  
  def original_filename
    story_board_attachment.present? ? story_board_attachment.upload.original_filename : image.original_filename
  end

end
