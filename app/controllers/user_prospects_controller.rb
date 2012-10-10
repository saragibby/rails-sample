class UserProspectsController < ApplicationController
  def create
    @user_prospect = UserProspect.new(params[:user_prospect])

    respond_to do |format|
      if @user_prospect.save
        format.html { redirect_to root_path, :notice => "Thank you for your interest!" }
      else
        format.html { redirect_to root_path, :notice => "Email invalid, or already signed up" }
      end
    end
  end
end
