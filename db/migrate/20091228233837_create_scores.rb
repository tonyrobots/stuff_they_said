class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.integer :score
      t.references :scorable, :polymorphic => true
      t.timestamps
    end
    add_column :statements, :score, :integer, :default => 0
  end

  def self.down
    drop_table :scores
    remove_column :statements, :score
  end
end
