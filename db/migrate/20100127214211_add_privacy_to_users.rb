class AddPrivacyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :privacy, :integer, :default => 1
  end

  def self.down
    remove_column :users, :privacy
  end
end
