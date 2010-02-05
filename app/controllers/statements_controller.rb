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
    message = @statement.content.gsub(/'/, "")
    if @statement.save
      render :update do |page|
        page.insert_html :after, "write_statement", :partial => 'shared/read_statement', :locals => { :statement => @statement, :moderate => false, :vote => true }
        page["statement_content"].value = ""
        @question = random_question(user.name)
        publish_to_fb(page, user, "Users Page", "http://user_page_link", message, "http://user_page_link")
      end
    end
  end  
  
  def describe_friend
    @statement = Statement.new(params[:statement])
    user_id = Whois.new_user(current_user.id, params[:fb_user], facebook_session)
    @statement.user_id = user_id
    if @statement.save
      redirect_to home_url
    end
  end
  
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
      question = random_question(params[:name])
      page.replace_html 'question', question
      page['statement_question'].value = question
    end
  end
  
  def vote
    begin
      statement = Statement.find params[:id]
      if params[:type] == "like"
        current_user.vote_for(statement)
        Statement.add_voter(true, current_user, statement)
      else
        current_user.vote_against(statement)  
        Statement.add_voter(false, current_user, statement)
      end
      pos_score = statement.votes_for
      neg_score = statement.votes_against
      score = pos_score - neg_score
      statement.update_attribute(:score, score)
      render :update do |page|
        page.replace_html "statement_vote_#{params[:id]}", score
        page.replace_html "#{params[:type]}-#{params[:id]}", "#{params[:type]}"
        page["#{params[:type]}-#{params[:id]}"].addClass('voted');
      end
    rescue ActiveRecord::StatementInvalid
      render :update do |page|
        page << "alert('Already voted!');"
      end
    rescue
    end
  end  
end
