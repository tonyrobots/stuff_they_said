module AuthlogicFacebookConnect
  module Helper
    def authlogic_facebook_login_button(options = {})
      # TODO: Make this with correct helpers istead of this uggly hack.
      
      options[:controller] ||= "user_session"
      options[:js] ||= :prototype
      
      case options[:js]
      when :prototype
        js_selector = "$('connect_to_facebook_form')"
      when :jquery
        js_selector = "jQuery('#connect_to_facebook_form')"
      end
      
      output = "<form id='connect_to_facebook_form' method='post' action='/#{options[:controller]}'>\n"
      output << "<input type='hidden' name='authenticity_token' value='#{form_authenticity_token}'/>\n"
      output << "</form>\n"
      output << "<script type='text/javascript' charset='utf-8'>\n"
      output << " function connect_to_facebook() {\n"
      output << "   #{js_selector}.submit();\n"
      output << " }\n"
      output << "</script>\n"
      options.delete(:controller)
      output << fb_login_button("connect_to_facebook()", options)
      output
    end
    
    
    def authlogic_facebook_logout_link(text, options = {})
      # TODO: Make this with correct helpers istead of this uggly hack.

      options[:controller] ||= "user_session"
      options[:js] ||= :prototype
      
      case options[:js]
      when :prototype
        js_selector = "$('facebook_logout_form')"
      when :jquery
        js_selector = "jQuery('#facebook_logout_form')"
      end
      
      output = "<form id='facebook_logout_form' method='post' action='/#{options[:controller]}'>\n"
      output += "<input type='hidden' name='authenticity_token' value='#{form_authenticity_token}'/>\n"
      output += "<input type='hidden' name='_method' value='delete'/>\n"
      output += "</form>\n"
      output += "<script type='text/javascript'>\n"
      output += " function facebook_logout() {\n"
      output += "    #{js_selector}.submit();return false;\n"
      output += " }\n"
      output += "</script>\n"
      options.delete(:controller)
      output += link_to_function(text, "FB.Connect.logout(facebook_logout)", options)
      output
    end    
  end
end
