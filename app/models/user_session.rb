class UserSession < Authlogic::Session::Base
  # after_create :update_profile
  # 
  # def update_profile
  #   Rails.logger.info ">>>>>>> #{self.id}"
  # end
end