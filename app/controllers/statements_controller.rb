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
    user = User.find params[:statement][:user_id], :select => "facebook_uid, name, permalink"
    message = @statement.question + " " + @statement.content.gsub(/'/, "")
    if @statement.save
      render :update do |page|
        page.insert_html :after, "write_statement", :partial => 'shared/read_statement', :locals => { :statement => @statement, :moderate => false, :vote => true }
        page["statement_content"].value = ""
        page["statement_fbpost"].value = "1"
        #@question = random_question(firstName(user.name))
        #was trying to make the question refresh upon posting,  but was getting tangled up with the objects not being available
        #page.replace_html "write_statement", :partial => "shared/write_statement", :locals => { :question => @question, :user_id => @user.id, :user_name => @user.name }
        #publish_to_fb(page, user, firstName(@statement.by) + "'s Stuff they Said profile", APPLICATION_URL + @statement.by_link, message, APPLICATION_URL)
        if (params[:statement][:fbpost] == "1")
          publish_to_fb(page, user, "Stuff They Said", APPLICATION_URL, message, APPLICATION_URL + user.permalink)
        end
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
      question = random_question(firstName(params[:name]))
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
        page.replace_html "statement_vote_#{params[:id]}", score_to_text(pos_score, neg_score, score)
        page.replace_html "#{params[:type]}-#{params[:id]}", image_tag("icons/#{params[:type]}d.png")
        page["#{params[:type]}-#{params[:id]}"].addClass('voted');
      end
    rescue ActiveRecord::StatementInvalid
      render :update do |page|
        page << "alert('Sorry, but you can only vote once!');"
      end
    rescue
    end
  end  
end
