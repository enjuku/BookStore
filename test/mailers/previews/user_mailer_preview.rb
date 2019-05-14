# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
    def welcome
        UserMailer.welcome_email('username','user@example.com')
    end
end
