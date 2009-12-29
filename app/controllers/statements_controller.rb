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
    if @statement.save
      render :update do |page|
        page.insert_html :after, "write_statement", :partial => 'shared/read_statement', :locals => { :statement => @statement, :moderate => false }
        page['statement_content'].value = ""
      end
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
  
  def vote
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
  end  
end
