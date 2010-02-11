# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


ActiveRecord::Base.connection.execute("Delete from badges")
cards = Badge.create([
  { :name=> 'BFF', :image_thumb=> 'card.gif'},
  { :name => 'Smartest', :image_thumb=> 'card.gif' },
  { :name => 'Hottest', :image_thumb=> 'card.gif' },
  { :name => 'Funniest', :image_thumb=> 'card.gif' },
  { :name => 'Most Eligible', :image_thumb=> 'card.gif' },
  { :name => 'Most Saintly', :image_thumb=> 'card.gif' },
  { :name => 'Naughtiest', :image_thumb=> 'card.gif' },
  { :name => 'Hardest Working', :image_thumb=> 'card.gif' },
  { :name => 'Call Me', :image_thumb=> 'card.gif' },
  { :name => 'WTF?', :image_thumb=> 'card.gif' }
  
])