class HomeController < ApplicationController
  layout 'home'
  before_filter :require_user, :only => [:welcome, :home]
  before_filter :require_no_user, :only => :root
  include ApplicationHelper
  rescue_from Facebooker::Session::SessionExpired, :with => :logout

  
  def root
    #render :layout => 'default' 
    @root = "root"
  end
  
  def logout
    current_user_session.destroy
    redirect_back_or_default root_url
  end
  
  def welcome
    @random_user = facebook_session.user.friends[rand(facebook_session.user.friends.length)]    
  end

  def home
    #@dtype = rand(2)  
    @dtype = 0
    if read_stream? 
      @random_user = User.random_fb_friend(facebook_session)
    else
      @random_user = facebook_session.user.friends[rand(facebook_session.user.friends.length)]    
    end
    if @dtype == 0
      @new_fb_user = facebook_session.fql_query("SELECT name,pic FROM user WHERE uid=#{@random_user}").first
      @question = random_question(firstName(@new_fb_user.name))
    end
    if current_user.login_count == 1
      @random_user = facebook_session.user.friends[rand(facebook_session.user.friends.length)]    
      current_user.increment! :login_count
      render :action => 'welcome'
    else
      users = current_user.friends.collect {|u| u.id}
      @notification = Activity.find_by_friend_id(current_user.id, :order => "created_at DESC")
      @activities = Activity.find_all_by_creator_id(users, :order => "created_at DESC", :offset => 3).paginate(:page => params[:page], :per_page => 10)
      render :layout => 'main'
    end
  end
end
