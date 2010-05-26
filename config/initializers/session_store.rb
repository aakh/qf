# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_qf_session',
  :secret      => 'fedaff10be95574b078861c32539aa58b7564f957c9b5ace25ff2c99e26fd92d6cb113a72ac9dabca92fd2f2b4f578239ffa67bbdb2f666fac6833f2385060f7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
