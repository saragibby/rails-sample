class StoryBoardAttachmentsController < ApplicationController
  def create
    @story_board = StoryBoard.find(params[:story_board_id])
    @story_board.attachments.create(:upload => params[:file])
    
    respond_to :js
  end
end