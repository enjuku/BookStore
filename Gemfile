source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

gem 'rails', '~> 5.2.0'
gem 'bcrypt', '~> 3.1', '>= 3.1.12'
gem 'request_store', '~> 1.4', '>= 1.4.1'
gem 'sqlite3'
gem 'launchy'
gem 'sidekiq', '~> 5.2', '>= 5.2.5'
gem 'puma', '~> 3.11'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'simple_form'
gem 'jquery-rails'
gem 'paperclip', "~> 6.0.0"
gem 'haml-rails', "~> 1.0"
gem 'bootsnap', '~> 1.3', '>= 1.3.2'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "letter_opener"
end

group :development do
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # gem "simplecov", "~> 0.16.1", :require => false
  gem 'simplecov'#, :require => false
  gem 'rspec-rails', '~> 3.8'
  gem 'rails-controller-testing'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]