source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
# Use Puma as the app server
# gem 'puma', '~> 3.0'
gem 'unicorn'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
 gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
  gem 'rack-cors'
  gem 'active_model_serializers'
  gem 'rack-attack'
  gem 'rack-timeout'
  gem 'stripe'
  gem 'stripe_event'
  gem 'http'
  gem 'annotate'
#Sending email via sendgrid
gem 'sendgrid-ruby'

#Sending email via mailgun
gem 'mailgun-ruby'
gem 'bunny'

#Gerenrate PDF
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
 gem 'delayed_job_active_record'
 gem "daemons"
 gem 'awesome_print'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

end

group :development do
  gem 'mysql2'
  gem 'annotate' 
  gem 'foreman'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'rails_12factor'
  gem 'pg'
  gem 'lograge'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
 gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
