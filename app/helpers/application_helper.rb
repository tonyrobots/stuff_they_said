# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def random_question(name)
    APP_QUESTIONS[rand(APP_QUESTIONS.length)].gsub('X', name)
  end
  

  def publish_to_fb(page, to_user, message)
    if current_user.settings[:publish_stream] == 0
      page << "first_publish(#{current_user.facebook_uid}, #{to_user.facebook_uid}, 'about me', 'http://google.com', \"#{message}\");"
    elsif current_user.settings[:publish_stream] == -1
      page << "fb_publish(#{current_user.facebook_uid}, #{to_user.facebook_uid}, 'about me', 'http://google.com', \"#{message}\", false);";
    else
      page << "fb_publish(#{current_user.facebook_uid}, #{to_user.facebook_uid}, 'about me', 'http://google.com', \"#{message}\", true);";
    end
  end
  
  def score_class(score)
    if score > 0 
      "pos"
    elsif score < 0
      "neg"
    else 
      "zero"
    end
  end
  
  def first_tag(user_tags, tag_id)
    good_tag = ""
    taggs = []
    for tag in user_tags
      taggs << tag if (tag.tag_id == tag_id)
    end
    "First tagged by #{link_to taggs.first.voter_name, '/'+taggs.first.voter_link}<br>"
  end
  
  def agree_tags(user_tags, tag_id)
    good_tags = ""
    for tag in user_tags
      good_tags << "<li>#{link_to tag.voter_name, '/'+tag.voter_link}</li>" if (tag.tag_id == tag_id && tag.tag_vote)
    end
    good_tags
    "<div class=\"tag_vote\"><ul><li>Agreed by </li>#{good_tags}</ul></div>" if good_tags != ""
  end

  def disagree_tags(user_tags, tag_id)
    good_tags = ""
    for tag in user_tags
      good_tags << "<li>#{link_to tag.voter_name, '/'+tag.voter_link}</li>" if (tag.tag_id == tag_id && !tag.tag_vote)
    end
    "<div class=\"tag_vote\"><ul><li>Disgreed by </li>#{good_tags}</ul></div>" if good_tags != ""
  end

  def tag_score(user_tags, tag_id)
    score = 0
    for tag in user_tags
      score +=1 if (tag.tag_id == tag_id && tag.tag_vote)
      score -=1 if (tag.tag_id == tag_id && !tag.tag_vote)
    end
    score
  end


end
