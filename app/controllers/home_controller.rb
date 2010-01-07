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
    if current_user.login_count == 1
      current_user.increment! :login_count
      @random_user = facebook_session.user.friends[rand(facebook_session.user.friends.length)]
      render :action => 'welcome'
    else
      render :layout => 'main'
    end
  end
end
