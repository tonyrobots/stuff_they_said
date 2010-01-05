class CreateWhois < ActiveRecord::Migration
  def self.up
    create_table :whois do |t|
      t.integer :version
      t.text :content
      t.integer :user_id
      t.integer :friend_id
      t.string :by
      t.string :by_link
      t.timestamps
    end
    
    add_column :users, :current_whois, :integer, :default => 0
  end
  
  def self.down
    drop_table :whois
    remove_column :users, :current_whois
  end
end
