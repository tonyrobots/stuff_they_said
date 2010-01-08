class BadgesController < ApplicationController

  def create
    friend = User.find params[:friend_id], :select => "image_thumb, permalink, name, id, facebook_uid"
    badge = Badge.new_badge(params[:id], friend, current_user)
    message = "#{current_user.name} gave a card to #{friend.name} saying #{badge.data[:badge_name]}"
    
    if current_user.settings[:publish_stream] == 1
      User.publishto_fb(facebook_session, current_user.facebook_uid, friend.facebook_uid, 'AboutMe', "http://google.com", message)
    end
        
    render :update do |page|
      page.hide "card_#{params[:id]}"
      page.insert_html :top, 'profile_cards_wrap', :partial => 'badges/card', :locals => { :card => badge }
      if current_user.settings[:publish_stream] == 0
        page << "first_publish(#{current_user.facebook_uid}, #{friend.facebook_uid}, 'about me', 'http://google.com', '#{message}');"
      elsif current_user.settings[:publish_stream] == -1
        page << "fb_publish(#{current_user.facebook_uid}, #{friend.facebook_uid}, 'about me', 'http://google.com', '#{message}', false);";
      end
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
