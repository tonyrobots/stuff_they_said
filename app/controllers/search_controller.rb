class SearchController < ApplicationController
  # before_filter :require_user

  def index
    if current_user
      sql = "select lookup.*  from  friendships  inner join users as lookup on friendships.friend_id = lookup.id where friendships.user_id=1 and lookup.name like '%#{params[:search]}%'"
      # @results = User.paginate_by_sql (sql, :page => params[:page], :per_page => 10)
      @everyone = User.count :conditions => ['name like ?', "%#{params[:search]}%"]
      @fb_friends = facebook_session.fql_query("select uid, name, pic_square from user where uid IN ( select uid2 from friend where uid1 = #{current_user.facebook_uid}) AND strpos(lower(name), '#{params[:search].downcase}') >= 0")
    else
      @results = User.search(params[:search], params[:page])
    end
  end
  
  def everyone
    @results = User.search(params[:search], params[:page])
  end
  
end

