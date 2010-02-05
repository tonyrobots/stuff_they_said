class UsersController < ApplicationController
  # before_filter :store_location
include ApplicationHelper
  
  def show
    @user = User.find_by_permalink params[:title], :include => [:statements, :tags, :badgeings]
    @whois = Whois.find @user.current_whois unless @user.current_whois == 0
    if @user.privacy == 0
      render "show_private"
    elsif current_user && current_user.permalink == params[:title]
      @badges = Badge.badges_left @user
      render  "show_me"
    elsif  current_user && User.are_friends?(current_user, @user, facebook_session) 
      @whois = Whois.new if @user.current_whois == 0
      @question = random_question(firstName(@user.name))
      render "show_friend"
    elsif @user.privacy == 2
      render "show_public"
    else 
      render "show_private"
    end
  end
  
  
  
  def check_user
    user = User.find_by_facebook_uid params[:fbuid]
    if user.nil?
      Whois.new_user(current_user.id, params[:fbuid], facebook_session)
      user = User.find_by_facebook_uid params[:fbuid]
    else
      User.friends(current_user.id, user.id) unless User.are_friends?(current_user, user, facebook_session)
    end
    redirect_to "/#{user.permalink}"
  end



  # this is used for user-defined settings, e.g. privacy and email
  def settings
    @user = current_user
    if request.post? and params[:user]   
      @user.update_attribute(:privacy, params[:user][:privacy].to_i)
      @user.update_attribute(:email, params[:user][:email])
      @user.update_attribute(:twitter, params[:user][:twitter])
      #current_user.save(false)
      flash[:notice] = "Settings updated."
      redirect_to user_page_path(current_user.permalink)
    end
  end



  def update
    current_user.update_attributes(params[:user])
    current_user.save(false)
    redirect_to user_page_path(current_user.permalink)
  end
  
  def update_settings
    current_user.settings[:read_stream] = params[:read_stream].to_i  if params[:read_stream]
    current_user.settings[:publish_stream] = params[:publish_stream].to_i  if params[:publish_stream]
    current_user.save(false)
    render :nothing => true
  end
  
end
