class HomeController < ApplicationController
  layout 'home'
  before_filter :require_user, :only => [:welcome, :home]
  before_filter :require_no_user, :only => :root
  def root
    
  end
  
  def welcome
    
  end

  def home
    if current_user.login_count == 1
      current_user.increment! :login_count
      render :action => 'welcome'
    else
      
      @random_user = facebook_session.user.friends[rand(facebook_session.user.friends.length)]
      
      
      render :layout => 'main'
    end
  end
end
