class StatementDefaultscore < ActiveRecord::Migration
  def self.up
    change_column :statements, :score, :integer, :default => 0
  end

  def self.down
  end
end
