class WhoisController < ApplicationController
  before_filter :require_user

  def index
    @whois = Whois.all
  end
  
  def show
    @whois = Whois.find_all_by_user_id(params[:id])
    render :partial => "history", :collection => @whois, :as => :whois
  end
  
  def new
    @whois = Whois.new
  end
  
  def create
    params[:whois][:user_id] = Whois.new_user(current_user.id, params[:whois][:fb_user], facebook_session) if params[:whois][:user_id].blank? 
    @whois = Whois.new(params[:whois])
    if @whois.save
    @user = User.find params[:whois][:user_id], :select => "id, name, current_whois, permalink"
      respond_to do |format|
        format.html { redirect_to user_page_url(@user.permalink) }
        format.js do
          render :update do |page|
            page.replace_html "user_whois", :partial => 'shared/new_whois', :locals => { :user => @user, :whois => @whois }
          end
        end
      end
    end
  end
  
  def edit
    @whois = Whois.find(params[:id])
  end
  
  def update
    @whois = Whois.find(params[:id])
    if @whois.update_attributes(params[:whois])
      flash[:notice] = "Successfully updated whois."
      redirect_to @whois
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @whois = Whois.find(params[:id])
    @whois.destroy
    flash[:notice] = "Successfully destroyed whois."
    redirect_to whois_url
  end
  
  def change_whois
    current_user.update_attribute(:current_whois, params[:id])
    whois = Whois.find params[:id]
    render :partial => "shared/read_whois", :locals => { :user => current_user.name, :note => whois, :edit => false, :change => true }
  end
  
  def describe_friend
    random_user = facebook_session.user.friends[rand(facebook_session.user.friends.length)]
    render :update do |page|
      page.replace_html "describe_friend_wrap", :partial => 'shared/describe_friend', :locals => { :fbuid => random_user }
    end
  end
  
  def get_close_friend 
    wall_users = facebook_session.fql_query("SELECT actor_id FROM stream WHERE source_id =#{current_user.facebook_uid} AND actor_id !=#{current_user.facebook_uid} limit 20")
    random_user = wall_users[rand(wall_users.length)]
    render :update do |page|
      page.replace_html "describe_friend_wrap", :partial => 'shared/describe_friend', :locals => { :fbuid => random_user["actor_id"] }
    end
  end
  
end
