class CreateStatements < ActiveRecord::Migration
  def self.up
    create_table :statements do |t|
      t.string :question
      t.text :content
      t.integer :user_id
      t.integer :friend_id
      t.integer :score
      t.string :by
      t.string :by_link
      t.timestamps
    end
  end
  
  def self.down
    drop_table :statements
  end
end
