class TagsController < ApplicationController
  before_filter :require_user, :only => [:vote_tag, :create]
  
  def index
    if current_user
      @tag = Tag.find_by_name params[:tag]
      friends_and_i = current_user.friends <<  current_user
      @results = friends_and_i.all(:joins => :taggings, :include => :taggings, :conditions => ["taggings.tag_id = ?", @tag.id]).uniq.paginate(:page => params[:page], :per_page => 20)
      @results.sort! {|x,y| y.taggings.count(:conditions => ["taggings.tag_id=? and taggings.tag_vote=?", @tag.id, 1]) <=> 
        x.taggings.count(:conditions => ["taggings.tag_id=? and taggings.tag_vote=?", @tag.id, 1])
        }    
    else
      @tag = Tag.find_by_name params[:tag]
      @results = User.all(:joins => :taggings, :include => :taggings, :conditions => ["taggings.tag_id = ?", @tag.id]).uniq.paginate(:page => params[:page], :per_page => 20)
      @results.sort! {|x,y| y.taggings.count(:conditions => ["taggings.tag_id=? and taggings.tag_vote=?", @tag.id, 1]) <=> 
        x.taggings.count(:conditions => ["taggings.tag_id=? and taggings.tag_vote=?", @tag.id, 1])
        }
      render :action => "everyone"
    end
  end
  
  def everyone
    @tag = Tag.find_by_name params[:tag]
    @results = User.all(:joins => :taggings, :include => :taggings, :conditions => ["taggings.tag_id = ?", @tag.id]).uniq.paginate(:page => params[:page], :per_page => 20)
    @results.sort! {|x,y| y.taggings.count(:conditions => "taggings.tag_id=5 and taggings.tag_vote=1") <=> 
      x.taggings.count(:conditions => "taggings.tag_id=5 and taggings.tag_vote=1")
      }    
  end

  def create
    user = User.find params[:user_id]
    tags = params[:tag].split(',')
    for tag in tags
      User.set_tag(Sanitize.clean(tag.downcase), current_user, user, true) if tag.length < 25
    end
    user.save(false)
    message = "#{current_user.name} said #{user.name} is #{params[:tag]}"

    render :update do |page|
      for tag in tags
        page.insert_html(:bottom, 'user_tags', "<li><a href=\"/tag/#{tag.strip}\">#{tag.strip}</a></li>") if tag.length < 25
        page["tag"].value = ""
      end
      publish_to_fb(page, user, "Users Page", "http://user_page_link", message, "http://user_page_link")
    end
  end
  
  def vote_tag
    tag_user = User.find params[:user]
    User.set_tag(params[:tag].downcase, current_user, tag_user, params[:state].to_i)
    redirect_to tag_path(params[:tag])
  end
end
