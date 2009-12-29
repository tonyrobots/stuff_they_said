class Whois < ActiveRecord::Base
  attr_accessible :version, :content, :user_id, :friend_id, :by
  belongs_to :user
  before_create :set_version
  after_create :set_current_version
  
  def set_version
    self.version +=1
  end

  def set_current_version
    self.user.update_attribute :current_whois, self.id
  end
end
