class SearchController < ApplicationController

  def index
    @results = User.search( params[:search], params[:page])
  end
end