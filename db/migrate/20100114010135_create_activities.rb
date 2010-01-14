class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.column :creator_id,       :integer
      t.column :friend_id,       :integer
      t.column :activity_type,    :string, :limit => 30
      t.column :activity_id,      :integer
      t.column :data,             :text
      t.timestamps
    end

    add_index :activities, [:creator_id, :friend_id,  :activity_type, :activity_id], :unique => true, :name => 'unique_activity'
  end

  def self.down
    drop_table :activities
  end
end
