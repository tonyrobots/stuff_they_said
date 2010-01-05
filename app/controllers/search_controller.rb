class SearchController < ApplicationController
  before_filter :require_user

  def index
    
    @friends = facebook_session.fql_query("select name from user where uid IN ( select uid2 from friend where uid1 = #{current_user.facebook_uid}) AND strpos(lower(name), '#{params[:search].downcase}') >= 0")
    @all_count = User.count :conditions => ['name like ?', "%#{params[:search]}%"]
  end
end