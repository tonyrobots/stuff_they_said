class BadgesController < ApplicationController

  def create
    Badgings.create :user_id => current_user.id, :badge_id => params[:id], :
  end

  def show
    cards = Badge.all :conditions => "giveable=1"
    render :update do |page|
      page.replace_html "card_frame", :partial => 'badges/card_frame', :locals => { :cards => cards, :user => current_user.id, :friend => params[:id] }
    end
  end
end
