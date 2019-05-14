class UserMailer < ApplicationMailer
    default from: "no-reply@book-store.org"
 
    def welcome_email(name, email)
      @name = name
      @email = email
      @url  = "http://localhost:3000/login"
      
      mail(to: @email, subject: "Welcome to BookStore!")
    end

    def reset_password_email(name, email, token)
      @name = name
      @email = email
      @token = token
      # @url = password_recovery_url(:id => token)

      mail(to: @email, subject: "Reset password at BookStore")
    end
end

