# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all
  layout 'main'
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  helper_method :facebook_session, :current_user_session, :current_user, :set_facebook_session, :read_stream?

  unless ActionController::Base.consider_all_requests_local
    rescue_from Exception,                            :with => :render_error
    rescue_from ActiveRecord::RecordNotFound,         :with => :render_not_found
    rescue_from ActionController::RoutingError,       :with => :render_not_found
    rescue_from ActionController::UnknownController,  :with => :render_not_found
    rescue_from ActionController::UnknownAction,      :with => :render_not_found
  end
  
private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end
  
  def read_stream?
    if current_user
      return !current_user.settings.nil? && current_user.settings[:read_stream] == 0
    end
  end
  
  
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to root_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      redirect_to home_url
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  # => 404 Error
  def render_not_found(exception)
    log_error(exception)
    activate_authlogic
    render :template => "/errors/404.html.erb", :status => 404
  end

  # => 500 Error
  def render_error(exception)
    log_error(exception)
    # notify_hoptoad(exception)
    activate_authlogic
    render :template => "/errors/500.html.erb", :status => 500
  end
end