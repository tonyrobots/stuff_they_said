class Whois < ActiveRecord::Base
  attr_accessible :version, :content, :user_id, :friend_id, :by, :by_link
  belongs_to :user
  # before_create :set_version
  after_create :set_current_version
  before_create :sanit 

  def sanit
    self.content = Sanitize.clean(self.content)
  end
  
  def self.new_user(cuser, fbuser, fb_session)
    logger.info "Creating New User #{fbuser}"
    check_user = User.find_by_facebook_uid fbuser
    if check_user.nil?
      new_fb_user = fb_session.fql_query("SELECT name,pic, pic_square, pic_big FROM user WHERE uid=#{fbuser}").first
      permalink = User.page_permalink(new_fb_user.name)
      user = User.new :name => new_fb_user.name, :image_thumb => new_fb_user.pic_square, :image_small => new_fb_user.pic, :image_large => new_fb_user.pic_big, :facebook_uid => fbuser, :permalink => permalink
      user.save_with_validation(false)
      User.friends(cuser, user.id)
      user.id
    else
      check_user.id
    end
  end
  
  def set_version
    self.version +=1
  end
  
  def set_current_version
    self.user.update_attribute :current_whois, self.id
  end
end
