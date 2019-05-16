class UserMailer < ActionMailer::Base
    default from: "no-reply@book-store.org"
 
    def welcome_email(name, email)
      @name = name
      @email = email
      
      mail(to: @email, subject: "Welcome to BookStore!")
    end

    def reset_password_email(name, email, token)
      @name = name
      @email = email
      @token = token

      mail(to: @email, subject: "Reset password at BookStore")
    end
end

