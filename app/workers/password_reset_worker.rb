class PasswordResetWorker
  include Sidekiq::Worker

  def perform(name, email, token)
    UserMailer.reset_password_email(name, email, token).deliver
  end

end
