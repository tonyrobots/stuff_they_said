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

end
