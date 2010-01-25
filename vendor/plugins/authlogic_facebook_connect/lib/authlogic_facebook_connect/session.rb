module AuthlogicFacebookConnect
  module Session
    def self.included(klass)
      klass.class_eval do
        extend Config
        include Methods
      end
    end

    module Config
      # What user field should be used for the facebook UID?
      #
      # This is useful if you want to use a single field for multiple types of
      # alternate user IDs, e.g. one that handles both OpenID identifiers and
      # facebook ids.
      #
      # * <tt>Default:</tt> :facebook_uid
      # * <tt>Accepts:</tt> Symbol
      def facebook_uid_field(value = nil)
        rw_config(:facebook_uid_field, value, :facebook_uid)
      end
      alias_method :facebook_uid_field=, :facebook_uid_field

      # What session key field should be used for the facebook session key
      #
      #
      # * <tt>Default:</tt> :facebook_session_key
      # * <tt>Accepts:</tt> Symbol
      def facebook_session_key_field(value = nil)
        rw_config(:facebook_session_key_field, value, :facebook_session_key)
      end
      alias_method :facebook_session_key_field=, :facebook_session_key_field

      # Class representing facebook users we want to authenticate against
      #
      # * <tt>Default:</tt> klass
      # * <tt>Accepts:</tt> Class
      def facebook_user_class(value = nil)
        rw_config(:facebook_user_class, value, klass)
      end
      alias_method :facebook_user_class=, :facebook_user_class

      # A chain of symbols of method names called in order to vivify a
      # user from your application from the facebook user session
      # credentials.  Each method is called in sequence until one
      # returns on a non-nil, non-false value, which should be the
      # application user.  Each method is passed the facebook_session
      # as its only argument.  If the last method in the chain builds a
      # new application user object, this is the equivalent to the old
      # style of creating a new user.
      #
      # * <tt>Default:</tt> [:find_by_facebook_uid, :build_new_user]
      # * <tt>Accepts:</tt> Array
      def facebook_application_user_vivify_chain(value = nil)
        rw_config(:facebook_application_user_vivify_chain, value, [:find_by_facebook_uid, :build_new_user])
      end
      alias_method :facebook_application_user_vivify_chain=, :facebook_application_user_vivify_chain

    end

    module Methods
      def self.included(klass)
        klass.class_eval do
          validate :validate_by_facebook_connect, :if => :authenticating_with_facebook_connect?
        end

        def credentials=(value)
          # TODO: Is there a nicer way to tell Authlogic that we don't have any credentials than this?
          values = [:facebook_connect]
          super
        end
      end

      def validate_by_facebook_connect
        facebook_session = controller.facebook_session
        #self.attempted_record = klass.find(:first, :conditions => { facebook_uid_field => facebook_session.user.uid })

        # call each vivify method and return the results of any
        # non-nil, non-false method in the chain
        self.attempted_record = facebook_application_user_vivify_chain.inject(nil) { |memo, vivify_method| !memo ? send(vivify_method, facebook_session) : memo }

        # if we've found an application user, either one that already
        # existed or one that is brand new, keep processing
        unless self.attempted_record.nil?
          # set the session key into the user account
          self.attempted_record.send("#{facebook_session_key_field}=", facebook_session.session_key) if self.attempted_record.respond_to?("#{facebook_session_key_field}=")

          # call either before or during connect callback based on the
          # state of the application user
          callback = self.attempted_record.new_record? ? :before : :during
          self.attempted_record.send("#{callback}_connect", facebook_session) if self.attempted_record.respond_to?("#{callback}_connect")

          # now save our user, which has either been found or created, but
          # has been imbued with the session_key at least
          self.attempted_record.save_with_validation(false)
        end
      end
      
      def destroy
        controller.clear_facebook_session_information() 
        super
      end

      def authenticating_with_facebook_connect?
        if controller.respond_to?(:controller) && controller.controller.respond_to?(:set_facebook_session)
          controller.set_facebook_session
          attempted_record.nil? && errors.empty? && controller.facebook_session
        end
      end

    private

      def facebook_uid_field
        self.class.facebook_uid_field
      end

      def facebook_session_key_field
        self.class.facebook_session_key_field
      end

      #def facebook_skip_new_user_creation
      #  self.class.facebook_skip_new_user_creation
      def facebook_user_class
        self.class.facebook_user_class
      end

      def facebook_application_user_vivify_chain
        self.class.facebook_application_user_vivify_chain
      end

      def find_by_facebook_uid(facebook_session)
        facebook_user_class.find(:first, :conditions => { facebook_uid_field => facebook_session.user.uid })
      end

      def build_new_user(facebook_session)
        facebook_user_class.new(facebook_uid_field => facebook_session.user.uid)
      end      
    end
  end
end
