require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module BookStore
  class Application < Rails::Application
    
    config.before_configuration do 
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file)).each do |k,v|
        ENV[k.to_s] = v
      end if File.exists?(env_file)
    end

    config.load_defaults 5.2

  end
end
