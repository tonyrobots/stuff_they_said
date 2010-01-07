class BadgesController < ApplicationController

  def create
    badge = Badge.new_badge(params[:id], params[:friend_id], current_user)
    render :update do |page|
      page.hide "card_#{params[:id]}"
      page.insert_html :top, 'profile_cards_wrap', :partial => 'badges/card', :locals => { :card => badge }
    end  
  end

  def show
    if current_user.badges_given.nil?
      cards = Badge.all :conditions => ["giveable = ?", true]
    else
      cards = Badge.all :conditions => ["giveable = ? and id NOT IN (?)", true, current_user.badges_given]
    end
    render :update do |page|
      page.replace_html "card_frame", :partial => 'badges/card_frame', :locals => { :cards => cards, :user => current_user.id, :friend => params[:id] }
    end
  end
end
