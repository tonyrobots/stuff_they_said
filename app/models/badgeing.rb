class Badgeing < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge
  serialize :data, Hash
  validates_uniqueness_of :badge_id, :scope => [:friend_id]
  after_create :add_badge_to_user
  after_destroy :remove_badge_to_user
  
  def add_badge_to_user
    user = User.find self.friend_id
    user.badges_given = [] if user.badges_given.nil?
    user.badges_given << self.badge_id
    user.save(false)
  end

  def remove_badge_to_user
    user = User.find self.friend_id
    user.badges_given.delete(self.badge_id)
    user.save(false)
  end
  
end