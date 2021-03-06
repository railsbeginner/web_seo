class WebsitesController < ApplicationController
  before_filter :authenticate_user!
  expose(:website, attributes: :website_params)
  expose(:websites) {current_user.websites.includes(:responses)}
  expose(:keyword)
  

  def create
    user_id = current_user.id
    if website.save
      redirect_to root_path
    else
      
      render 'index'
    end
  end

  def index

  end

  private

  def website_params
    params.require(:website).permit(:name, :user_id, :average_response_time)
  end
end
