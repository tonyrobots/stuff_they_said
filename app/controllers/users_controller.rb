class UsersController < ApplicationController
  # before_filter :store_location

  def show
    @user = User.find_by_permalink params[:title], :include => :statements
    @whois = Whois.find @user.current_whois unless @user.current_whois == 0

    if current_user
      if current_user.permalink == params[:title]
        render  "show_me"
      else
        @whois = Whois.new if @user.current_whois == 0
        render "show_friend"
      end
    else
      render "show_public"
    end
  end
  
end
