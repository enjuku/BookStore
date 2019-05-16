namespace :tokens do
    desc 'Removes expired tokens'
    task :remove_expired => :environment do
      Token.destroy_expired
    end
  end