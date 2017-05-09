require 'sendgrid-ruby'


 Rails.configuration.sendgrid = {
  :secret_key             => ENV['SENDGRID_API_KEY'] 
}

 