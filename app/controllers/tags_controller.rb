class TagsController < ApplicationController
  
  def index
    @results = User.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 20)
  end

  def create
    user = User.find params[:user_id]
    user.tag_list << params[:tag]
    user.save(false)
    render :update do |page|
      page.insert_html :bottom, 'user_tags', "<li><a href=\"/tag/#{params[:tag]}\">#{params[:tag]}</a></li>"
    end
  end
end
