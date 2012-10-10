class StoryBoard < ActiveRecord::Base
  include Shared::AttachmentHelper
  include Shared::SlideCreator 
  
  belongs_to :user
  has_many :slides, :order => "order_number", :dependent => :destroy
  has_many :attachments, :foreign_key => 'story_board_id', :class_name => 'StoryBoardAttachment', :dependent => :destroy
  # accepts_nested_attributes_for :attachments, :allow_destroy => true 
  
  validates_presence_of :title
  
  attr_accessor :starting_order_number
  
  before_save   :set_dirty_flag
  after_save    :schedule_worker
  
  DEFAULT_TITLE = 'Untitled'
  DEFAULT_BACKGROUND = 'Web 1024'
  FILE_TYPES_ALLOWED = ['.PDF','.JPG','.PNG','.GIF']
  
  def duplicate
    dup_story_board = StoryBoard.create(:user_id => self.user_id, :title => get_next_duplicate_title, :background => self.background, :duplicating => true)    
    schedule_duplicate(dup_story_board)  
    dup_story_board
  end
  
  def mobile_safari_layout?
    background == "iPad" || background == "iPhone"
  end
  
  def clean?
    !dirty? && !self.duplicating
  end
  
  def private?
    self.security_level == 'private'
  end
  
  def valid_password?(user_entered_password)
    self.password == user_entered_password
  end
  
  def security_level_desc
    {'public' => 'Public on the web', 'link' => 'Anyone with link', 'private' => 'Private'}[self.security_level]
  end
  
  def variables
    variables = []
    slides.each do |slide|
      slide.action_items.each do |action_item|
        if action_item.data_attrs['data_save_variable'].present?
          variables.push(action_item.data_attrs['data_save_variable'])
        end
      end
    end
    return variables
  end
  
  def has_slides?
    slides.count > 0
  end
  
  def get_next_duplicate_title      
    for i in 1..100
      title = "#{self.title} #{i}"
      break if self.user.story_boards.where(:title => title).size == 0
    end 
    title
  end
  
  def attachments_present?
    if slides.size == 0 && attachments.not_processed.size == 0
      errors.add(:attachments, "need to be uploaded before you can save")
      false
    else 
      true
    end
  end
  
  def empty_links_to(deleting_slide)
    story_board_internal_links = self.slides.map(&:internal_link_action_items).reject{|l| l.blank?}.flatten
    action_items_to_update = story_board_internal_links.select{|l| l.data["internal_link"] == "#{deleting_slide.id}"}
    action_items_to_update.map(&:remove_internal_link)
  end
  
  def attachments_attributes=(attributes)
    attributes.each{ |a| self.attachments.create :upload => a }
  end
  
  def json_response
    self.attachments.size > 0 ? self.attachments.map(&:to_fileupload_json) : self
  end
  
  private

    def schedule_duplicate(dup_story_board)  
      Delayed::Job.enqueue(StoryBoardDuplicateJob.new(self.id, dup_story_board.id))
    end
    
    def schedule_worker  
      Delayed::Job.enqueue(StoryBoardJob.new(self.id, @starting_order_number || 0)) if self.dirty?
    end
    
    def set_dirty_flag
      self.dirty = true if attachments.not_processed.size > 0
    end
    
end
