class Badge < ActiveRecord::Base

  def self.new_badge(badge_id, friend, user)
    badge = Badge.find badge_id
    data = {
      :user_name => friend.name,
      :user_thumb => friend.image_thumb,
      :user_permalink => friend.permalink, 
      :friend_name => user.name,
      :friend_thumb => user.image_thumb,
      :friend_permalink => user.permalink, 
      :badge_name =>  badge.name,
      :badge_thumb => badge.image_thumb
    }
    new_badgeing = Badgeing.create :user_id => friend.id, :badge_id => badge_id, :friend_id => user.id, :data => data
    new_badgeing
  end



  def self.badges_left (user)
    if user.badges_given.nil?
      cards = Badge.count :conditions => ["giveable = ?", true]
    else
      cards = Badge.count :conditions => ["giveable = ? and id NOT IN (?)", true, user.badges_given]
    end
    cards
  end
  
end