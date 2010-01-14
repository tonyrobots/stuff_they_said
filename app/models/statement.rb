class Statement < ActiveRecord::Base
  attr_accessible :vote_data, :by, :user_id, :content, :by_link, :friend_id
  acts_as_voteable
  serialize :vote_data
  before_create :initialize_vote_data
  after_create  :wrote_statement
  has_one :activity, :foreign_key => "activity_id", :dependent => :destroy  
  
  def wrote_statement
    Activity.add_statement(self)
  end
  
  def initialize_vote_data
    self.vote_data = {
      :likers => [], 
      :dislikers => []
    }
  end

  def self.add_voter(like, current_user, statement)
    user = {
      :id => current_user.id,
      :name => current_user.name,
      :permalink => current_user.permalink
    }
    if like
      statement.vote_data[:likers] << user
    else
      statement.vote_data[:dislikers] << user
    end
    statement.save(false)
  end
end
