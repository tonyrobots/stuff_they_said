class WhoisController < ApplicationController
  def index
    @whois = Whois.all
    
  end
  
  def show
    @whois = Whois.find_all_by_for_user_id(params[:id])
    render :partial => "history", :collection => @whois, :as => :whois
  end
  
  def new
    @whois = Whois.new
  end
  
  def create
    @whois = Whois.new(params[:whois])
    @user = User.find params[:whois][:for_user_id], :select => "id, name, current_whois"
    if @whois.save
      render :update do |page|
        page.replace_html "user_whois", :partial => 'shared/new_whois', :locals => { :user => @user, :whois => @whois }
      end
    end
  end
  
  def edit
    @whois = Whois.find(params[:id])
  end
  
  def update
    @whois = Whois.find(params[:id])
    if @whois.update_attributes(params[:whois])
      flash[:notice] = "Successfully updated whois."
      redirect_to @whois
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @whois = Whois.find(params[:id])
    @whois.destroy
    flash[:notice] = "Successfully destroyed whois."
    redirect_to whois_url
  end
end
