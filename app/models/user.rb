class User < ActiveRecord::Base
  acts_as_authentic 
  acts_as_voter
  acts_as_tagger
  acts_as_taggable_on :tags  
  attr_accessible :name, :login_count, :permalink, :current_whois, :image_thumb, :facebook_uid, :image_large, :image_small, :settings
  has_many :whoiss, :foreign_key => :user_id
  has_many :statements, :order => "created_at DESC"
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  has_many :badgeings
  has_many :badges, :through => :badgeings
  has_many :activities, :foreign_key => "creator_id", :order => "created_at DESC"
  
  serialize :badges_given
  serialize :settings
    
  def self.set_tag(tag, user, tag_user, state)
    new_tag = Tag.find_or_create_with_like_by_name(tag)
    tagging = Tagging.create( :tag_id => new_tag.id, :context => "tags", 
                    :taggable => tag_user, :tagger => user, :voter_name => user.name, :voter_link => user.permalink, :tag_vote => state)
    Activity.tag_friend(tagging)
  end


  def self.friends(user, friend)
    friendship = User.find(user).friendships.build(:friend_id => friend)
    friendship.save
  end
  
  def self.are_friends?(cu, user, fb_session)
    is_friend = cu.friendships.first :conditions => {:friend_id => user.id}
    unless is_friend
      if fb_session.user.friends_with?(user.facebook_uid)
        User.friends(cu.id, user.id)
      else
        false
      end
    else
      true
    end
  end
  
  def before_connect(facebook_session)
    self.settings = {
      :read_stream => 0, 
      :publish_stream => 0,
      :last_publish => nil
    }
    self.name = facebook_session.user.name
    self.image_thumb = facebook_session.user.pic_square
    self.image_small = facebook_session.user.pic
    self.image_large = facebook_session.user.pic_big
    self.permalink = User.page_permalink(facebook_session.user.name)
  end

  def during_connect(facebook_session)
    self.image_thumb = facebook_session.user.pic_square
    self.image_small = facebook_session.user.pic
    self.image_large = facebook_session.user.pic_big
    self.save(false)
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
  
  def self.publishto_fb(fb_session, from, to, action_name, action_link, message, message_link)

    attachment = {
      :name =>  message,
		  :href => action_link
	  }
    links = [ :text => action_name, :href => action_link ]
    fb_to = Facebooker::User.new :id => to
    
    fb_session.user.publish_to(
      fb_to,  
      :message => '', 
      :action_links => links,
      :attachment => attachment
      
    )     
  end
  
  def self.random_fb_friend(facebook_session)
    if(rand(2) == 1)
      facebook_session.user.friends[rand(facebook_session.user.friends.length)]  
    else
      wall_users = facebook_session.fql_query("SELECT actor_id FROM stream WHERE source_id =#{facebook_session.user.uid} AND actor_id !=#{facebook_session.user.uid} limit 20")
      random_user = wall_users[rand(wall_users.length)]
      random_user["actor_id"]
    end
  end


end
