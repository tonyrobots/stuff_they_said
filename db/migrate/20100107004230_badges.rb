class Badges < ActiveRecord::Migration
  def self.up
    create_table :badges do |t|
      t.column :name, :string
      t.column :image_thumb, :string
      t.column :giveable, :boolean, :default => true
      t.column :times_given, :integer, :default => 0
      t.timestamp
    end
    
    create_table :badgeings  do |t|
      t.column :badge_id, :integer
      t.column :user_id, :integer
      t.column :friend_id, :integer
      t.column :data, :text
      t.timestamp
    end
    
    add_index :badgeings, :badge_id
    add_index :badgeings, :user_id
    
    add_column :users, :badges_given, :text
  end
  
  def self.down
    drop_table :badges
    drop_table :badgeings
  end
end
