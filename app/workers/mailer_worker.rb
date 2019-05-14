class MailerWorker
  include Sidekiq::Worker

  def perform(name, email)
    UserMailer.welcome_email(name, email).deliver
  end

end
