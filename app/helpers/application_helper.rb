# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def random_question(name)
    APP_QUESTIONS[rand(APP_QUESTIONS.length)].gsub('X', name)
  end
end
