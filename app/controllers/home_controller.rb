class HomeController < ApplicationController
  layout 'home'
  before_filter :require_user, :only => [:welcome, :home]
  before_filter :require_no_user, :only => :root
  def root
    
  end
  
  def welcome
    @random_user = facebook_session.user.friends[rand(facebook_session.user.friends.length)]    
  end

  def home
    @dtype = rand(2)  
    @random_user = User.random_fb_friend(facebook_session)
    if @dtype == 0
      @new_fb_user = facebook_session.fql_query("SELECT name,pic FROM user WHERE uid=#{@random_user}").first
    end
    if current_user.login_count == 1
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
