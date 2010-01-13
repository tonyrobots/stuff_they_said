class TagsController < ApplicationController
  before_filter :require_user
  
  def index
    @tag = Tag.find_by_name params[:tag]
    @results = current_user.friends.all(:joins => :taggings, :include => :taggings, :conditions => ["taggings.tag_id = ?", @tag.id]).uniq.paginate(:page => params[:page], :per_page => 20)
    
    
    # sql = "select lookup.*  from  friendships  inner join users as lookup on friendships.friend_id = lookup.id where friendships.user_id=1 and lookup.name like '%#{params[:search]}%'"
    # @results = User.find_by_sql sql
    
    # @results = User.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 20).uniq
  end

  def create
    user = User.find params[:user_id]
    tags = params[:tag].split(',')
    for tag in tags
      User.set_tag(tag.downcase, current_user, user)
    end
    user.save(false)
    message = "#{current_user.name} tagged #{user.name} as #{params[:tag]}"

    render :update do |page|
      for tag in tags
        page.insert_html :bottom, 'user_tags', "<li><a href=\"/tag/#{tag.strip}\">#{tag.strip}</a></li>"
        page["tag"].value = ""
      end
      publish_to_fb(page, user, message)
    end
  end
end
