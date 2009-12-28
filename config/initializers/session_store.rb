# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_aboutme_session',
  :secret      => 'aa44e89a688b691e00a1634cab970f60031675b4ee6313df0f85a7d3f76c42af7a123f2726f267b829fe3d81fa017187a95a502c9274aff2d2e8bd581b366bdd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
