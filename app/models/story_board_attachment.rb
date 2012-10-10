class StoryBoardAttachment < ActiveRecord::Base
  include Shared::AttachmentHelper 
  
  belongs_to :story_board
  has_many :slides
     
  has_attachment :upload, :path => "/story_boards/:story_board_id/attachments/:id/:basename.:extension"
  
  scope :not_processed, where(:processed => false)
  
  def to_fileupload_json
    {
      "name" => upload_file_name,
      "size" => upload_file_size,
      "url" => upload.url,
      "thumbnail_url" => upload.url,
      "story_board_id" => story_board_id
    }
  end
end
