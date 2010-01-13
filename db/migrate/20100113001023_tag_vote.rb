class TagVote < ActiveRecord::Migration
  def self.up
    add_column :taggings, :tag_vote, :boolean, :default => true
  end

  def self.down
    remove_column :taggings, :tag_vote
  end
end
