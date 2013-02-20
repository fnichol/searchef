source 'https://rubygems.org'

# Specify your gem's dependencies in searchef.gemspec
gemspec

group :development do
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
end

group :test do
  gem 'rake', '~> 0.9'

  # allow CI to override the version of Chef for matrix testing
  gem 'chef', (ENV['CHEF_VERSION'] || '>= 0.10.10')
end
