class UsersController < ApplicationController
  # before_filter :store_location

  def show
    @user = User.find_by_permalink params[:title], :include => :statements
    @whois = Whois.find @user.current_whois unless @user.current_whois == 0
    if current_user && current_user.permalink == params[:title]
      @badges = User.badges_left @user
      render  "show_me"
    elsif current_user && User.are_friends?(current_user, @user, facebook_session)
      @whois = Whois.new if @user.current_whois == 0
      render "show_friend"
    else
      render "show_public"
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
end
