class User < ActiveRecord::Base
  acts_as_authentic 
  acts_as_voter
  attr_accessible :name, :login_count, :permalink, :current_whois
  has_many :whoiss, :foreign_key => :user_id
  has_many :statements, :order => "created_at DESC"
  
  
  def before_connect(facebook_session)
    self.name = facebook_session.user.name
    self.image_thumb = facebook_session.user.pic_square
    self.image_small = facebook_session.user.pic
    self.image_large = facebook_session.user.pic_big
    self.permalink = page_permalink
  end

  def page_permalink
    page_token = "#{self.name.gsub(' ', '-')}"
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
  
end
