class FixWhoisColumns < ActiveRecord::Migration
  def self.up
    add_column :whois, :by_link, :string
    rename_column :whois, :for_user_id, :user_id
    rename_column :whois, :by_user_id, :friend_id
  end

  def self.down
  end
end
