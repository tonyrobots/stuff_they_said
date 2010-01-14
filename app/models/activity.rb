class Activity < ActiveRecord::Base
  validates_presence_of :creator_id, :friend_id, :activity_type, :activity_id, :data
  serialize :data, Hash
  
  # => User took back card from friend (badge destrot)
  # => User tagged a friend (tag create)
  # => User described friend as (whois create)
  
  # => User wrote about friend (statement)
  def self.add_statement(statement)
    user = User.find statement.user_id, :select => "name, permalink, image_thumb"
    creator_thumb =  User.find(statement.friend_id, :select => "image_thumb").image_thumb
    data = {
      :creator_name => statement.by, 
      :creator_link => statement.by_link, 
      :creator_thumb => creator_thumb, 
      :friend_name => user.name, 
      :friend_link => user.permalink, 
      :friend_thumb => user.image_thumb,      
      :content => statement.content
    }
    begin
      create(
        :creator_id => statement.friend_id,
        :friend_id => statement.user_id,
        :activity_type => "wrote_statement",
        :activity_id => statement.id, 
        :data => data
      )
    rescue Exception => e
    end
  end
  
  
  # => User gave friend a card (badge create) 
  def self.gave_badge(badging)
    data = badging.data
    begin
      create(
        :creator_id => badging.friend_id,
        :friend_id => badging.user_id,
        :activity_type => "gave_badge",
        :activity_id => badging.id, 
        :data => data
      )
    rescue Exception => e
    end
  end
  
  def self.took_badge(badging)
    data = badging.data
    begin
      create(
        :creator_id => badging.friend_id,
        :friend_id => badging.user_id,
        :activity_type => "took_badge",
        :activity_id => badging.id, 
        :data => data
      )
    rescue Exception => e
    end
  end
  
  def self.tag_friend(tagging)
    user = User.find tagging.taggable_id, :select => "name, permalink, image_thumb"
    creator_thumb =  User.find(tagging.tagger_id, :select => "image_thumb").image_thumb
    tag = Tag.find tagging.tag_id
    data = {
      :creator_name => tagging.voter_name, 
      :creator_link => tagging.voter_link, 
      :creator_thumb => creator_thumb, 
      :friend_name => user.name, 
      :friend_link => user.permalink, 
      :friend_thumb => user.image_thumb,      
      :tag_id => tag.id,
      :tag_name => tag.name,
      :agree =>  tagging.tag_vote
    }
    begin
      create(
        :creator_id => tagging.tagger_id,
        :friend_id => tagging.taggable_id,
        :activity_type => "tagged",
        :activity_id => tagging.id, 
        :data => data
      )
    rescue Exception => e
    end
  end
  
end
