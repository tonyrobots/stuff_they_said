class StatementsController < ApplicationController
  def index
    @statements = Statement.all
  end
  
  def show
    @statement = Statement.find(params[:id])
  end
  
  def new
    @statement = Statement.new
  end
  
  def create
    @statement = Statement.new(params[:statement])
    user = User.find params[:statement][:user_id], :select => "facebook_uid, name"
    message = "#{current_user.name} wrote a statment about #{user.name}: #{@statement.content}"    
    if @statement.save
      render :update do |page|
        page.insert_html :after, "write_statement", :partial => 'shared/read_statement', :locals => { :statement => @statement, :moderate => false, :vote => true }
        publish_to_fb(page, user, message)
      end
    end
  end
  

  
    # 
    # if current_user.settings[:publish_stream] == 0
    #   page << "first_publish(#{current_user.facebook_uid}, #{user.facebook_uid}, 'about me', 'http://google.com', '#{message}');"
    # elsif current_user.settings[:publish_stream] == -1
    #   page << "fb_publish(#{current_user.facebook_uid}, #{user.facebook_uid}, 'about me', 'http://google.com', '#{message}', false);"
    # else
    #   page << "fb_publish(#{current_user.facebook_uid}, #{user.facebook_uid}, 'about me', 'http://google.com', '#{message}', true);"
    # end
  
  
  def edit
    @statement = Statement.find(params[:id])
  end
  
  def update
    @statement = Statement.find(params[:id])
    if @statement.update_attributes(params[:statement])
      flash[:notice] = "Successfully updated statement."
      redirect_to @statement
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @statement = Statement.find(params[:id])
    @statement.destroy
    render :update do |page|
      page.visual_effect "toggle_blind", "read_statement#{params[:id]}"
    end
  end
  
  def change_question
    render :update do |page|
      page['statement_content'].value = random_question(params[:name])
    end
  end
  
  def vote
    begin
      statement = Statement.find params[:id]
      if params[:type] == "like"
        current_user.vote_for(statement)  
      else
        current_user.vote_against(statement)  
      end
      pos_score = statement.votes_for
      neg_score = statement.votes_against
      score = pos_score - neg_score
      statement.update_attribute(:score, score)
      render :update do |page|
        page.replace_html "statement_vote_#{params[:id]}", score
      end
    rescue ActiveRecord::StatementInvalid
      render :update do |page|
        page << "alert('Already voted!');"
      end
    rescue
    end
  end  
end
