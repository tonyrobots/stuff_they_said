class TagVoterData < ActiveRecord::Migration
  def self.up
    add_column :taggings, :voter_name, :string 
    add_column :taggings, :voter_link, :string 
    Tagging.delete_all
  end

  def self.down
    remove_column :taggings, :voter_name
    remove_column :taggings, :voter_link
  end
end
