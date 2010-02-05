class AddTwitterToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter, :text
  end

  def self.down
    remove_column :users, :twitter
  end
end
