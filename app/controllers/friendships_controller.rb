class FriendshipsController < ApplicationController
  def create
    @friendship = Friendship.new(params[:friendship])
    if @friendship.save
      flash[:notice] = "Successfully created friendship."
      redirect_to friendships_url
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy
    flash[:notice] = "Successfully destroyed friendship."
    redirect_to friendships_url
  end
end
