class HomeController < ApplicationController
  layout 'home'
  before_filter :require_user, :only => [:welcome, :home]
  before_filter :require_no_user, :only => :root
  def root
    
  end
  
  def welcome
    
  end

  def home
    if current_user.login_count == 0
      current_user.increment! :login_count
      render :action => :welcome
    else
      render :layout => 'main'
    end
  end
end
