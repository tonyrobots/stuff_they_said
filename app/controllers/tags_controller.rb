class TagsController < ApplicationController
  before_filter :require_user
  
  def index
    @results = User.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 20)
  end

  def create
    user = User.find params[:user_id]
    user.tag_list << params[:tag]
    user.save(false)
    message = "#{current_user.name} tagged #{user.name} as #{params[:tag]}"

    if current_user.settings[:publish_stream] == 1
      User.publishto_fb(facebook_session, current_user.facebook_uid, user.facebook_uid, 'AboutMe', "http://google.com", message)
    end 

    render :update do |page|
      page.insert_html :bottom, 'user_tags', "<li><a href=\"/tag/#{params[:tag]}\">#{params[:tag]}</a></li>"
      if current_user.settings[:publish_stream] == 0
        page << "first_publish(#{current_user.facebook_uid}, #{user.facebook_uid}, 'about me', 'http://google.com', '#{message}');"
      elsif current_user.settings[:publish_stream] == -1
        page << "fb_publish(#{current_user.facebook_uid}, #{user.facebook_uid}, 'about me', 'http://google.com', '#{message}', false);";
      end
    end
  end
end
