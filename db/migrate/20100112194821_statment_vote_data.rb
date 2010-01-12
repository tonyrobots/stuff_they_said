class StatmentVoteData < ActiveRecord::Migration
  def self.up
    add_column :statements, :vote_data, :text
  end

  def self.down
    remove_column :statements, :vote_data
  end
end
