# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def random_question(name)
    APP_QUESTIONS[rand(APP_QUESTIONS.length)].gsub('{name}', name)
  end
  
  def userThumb(userid, link=0)
    user = User.find(userid, :select => "image_thumb, permalink")
    thumbnail,permalink = user.image_thumb, user.permalink
    tag = image_tag thumbnail
    if (link == 1)
      link_to tag, permalink
    end
  end

def firstName (name)
  name.scan(/\w+/)[0]
end

  def publish_to_fb(page, to_user, action, action_link, message, message_link)
    if current_user.settings[:publish_stream] == 0
      page << "first_publish(#{current_user.facebook_uid}, #{to_user.facebook_uid}, '#{action}', '#{action_link}', '#{message}', '#{message_link}');"
    elsif current_user.settings[:publish_stream] == -1
      page << "fb_publish(#{current_user.facebook_uid}, #{to_user.facebook_uid}, '#{action}', '#{action_link}', '#{message}', '#{message_link}', false);";
    else
      page << "fb_publish(#{current_user.facebook_uid}, #{to_user.facebook_uid}, '#{action}', '#{action_link}', '#{message}', '#{message_link}', true);";
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
    first_tag = user_tags.first
    for tag in user_tags
      good_tags << "<li>#{link_to tag.voter_name, '/'+tag.voter_link}</li>" if (tag.tag_id == tag_id && tag.tag_vote && tag != first_tag)
    end
    good_tags
    "<div class=\"tag_vote\"><ul><li>Agreed by </li>#{good_tags}</ul></div>" if good_tags != ""
  end

  def disagree_tags(user_tags, tag_id)
    good_tags = ""
    first_tag = user_tags.first
    for tag in user_tags
      good_tags << "<li>#{link_to tag.voter_name, '/'+tag.voter_link}</li>" if (tag.tag_id == tag_id && !tag.tag_vote && tag != first_tag)
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
  
  def user_notificaion(activity)
     if activity.activity_type == "wrote_statement" 
       "#{activity.data[:creator_name]} wrote about you! #{link_to 'Check it out!', activity.data[:friend_link]}"
		 elsif activity.activity_type == "tagged"  
       "#{activity.data[:creator_name]} tagged you! #{link_to 'Check it out!', activity.data[:friend_link]}"
		 elsif activity.activity_type == "gave_badge" 
       "#{activity.data[:friend_name]} gave you a badge! #{link_to 'Check it out!', activity.data[:user_link]}"
		 elsif activity.activity_type == "took_badge" 
       "#{activity.data[:friend_name]} took a badge away from you! #{link_to 'Check it out!', activity.data[:user_link]}"
		 end 
  end
end
