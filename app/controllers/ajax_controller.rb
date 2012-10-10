class AjaxController < ApplicationController
  def editable
    model = params[:id].scan(/(\D+)_(\D+)_/)[0][0].camelize.constantize
    object = model.find(params[:id].scan(/\d+/)[0])
    attribute = params[:id].scan(/(\D+)_(\D+)_/)[0][1]
    result = object.update_attribute attribute, params[:value]
    
    respond_to do |wants|
      wants.js { render :json => params[:value] }
    end
  end
end
