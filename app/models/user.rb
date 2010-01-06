class User < ActiveRecord::Base
  acts_as_authentic 
  acts_as_voter
  attr_accessible :name, :login_count, :permalink, :current_whois, :image_thumb, :facebook_uid, :image_large, :image_small
  has_many :whoiss, :foreign_key => :user_id
  has_many :statements, :order => "created_at DESC"
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  def self.friends(user, friend)
    friendship = User.find(user).friendships.build(:friend_id => friend)
    friendship.save
  end
  
  
  def self.are_friends?(cu, user)
    cu.friendships.first :conditions => {:friend_id => user.id}
  end
  
  def before_connect(facebook_session)
    self.name = facebook_session.user.name
    self.image_thumb = facebook_session.user.pic_square
    self.image_small = facebook_session.user.pic
    self.image_large = facebook_session.user.pic_big
    self.permalink = User.page_permalink(facebook_session.user.name)
  end


  def self.page_permalink(name)
    page_token = "#{name.gsub(' ', '-')}"
    page = User.find_by_permalink page_token
    if page.nil? 
      return page_token
    else
      token_count = page.permalink[/\d+/].to_i+1
      new_token = "#{page_token}-#{token_count}"
      return new_token
    end
  end
  
  def set_welcome_path
    session[:return_to] = '/welcome'
  end
  
  def self.search(search, page)
    paginate :per_page => 5, :page => page,
             :conditions => ['name like ?', "%#{search}%"], :order => 'name'
  end  
  

end
