class Badgeing < ActiveRecord::Base
  belongs_to :user
  belongs_to :badge
  serialize :data, Hash
end