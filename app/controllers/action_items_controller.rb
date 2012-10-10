class ActionItemsController < ApplicationController
  def create
    @action_item = ActionItem.new(params[:action_item])

    if @action_item.save
      render :json => { :action_item => @action_item }, :status => :created
    else
      render :json => @action_item.errors, :status => :unprocessable_entity
    end
  end

  def update
    
    @action_item = ActionItem.find(params[:action_item_id])
    attributes = params[:action_item]

    if @action_item.action_type == 'link' && params[:action_item][:data].present?
      if params[:action_item][:data][:internal_link] == 'external'
        attributes[:data][:link_type] = 'external'
        attributes[:data][:internal_link] = ''
      else
        attributes[:data][:link_type] = 'internal'
        attributes[:data][:external_link] = ''
      end
    end

    respond_to do |format|
      if @action_item.update_attributes(attributes)
        format.json { render :json => @action_item.to_json }
        format.js
      else
        format.json  { render :json => @action_item.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @action_item = ActionItem.find(params[:id])
    @action_item.destroy
    render :json => {}, :status => :ok
  end

end
