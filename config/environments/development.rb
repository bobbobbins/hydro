HydroFlask::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  #config.whiny_nils = true
  config.eager_load = false
  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  
  #------------- MAIL -------------------------------------------------------
  config.action_mailer.default_url_options = { :host => '54.231.130.113:3000' }
  
  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  config.action_mailer.raise_delivery_errors = true
  
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp

  # Settings from the "SMTP & API Credentials" Mandrill screen
  # :domain must be specific to the environment file
  #
  # For Mandrill API info, see:  https://mandrillapp.com/api/docs/
  config.action_mailer.smtp_settings = {
    address:  "smtp.mandrillapp.com",
    port:  587,
    enable_starttls_auto: true, 
    domain:  "hydroflask.com", 
    user_name:  "david@aztec-apps.com", # the Mandrill SMTP User Name
    password: "apXxhrev9ONKex6lWTejMw",  # the Mandrill SMTP API key
    authentication: 'login'
  }
  #--------------------------------------------------------------------------

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  #config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = false  # set to true only to debug (it creates too much garbage data in the logs)

  config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

end
