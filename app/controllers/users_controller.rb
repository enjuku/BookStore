class UsersController < ApplicationController

  before_action :redirect_if_logged, only: [:login, :signup]

  def login  
    if request.post?
      user = User.find_by(email: params[:session][:email].downcase)

      if user && user.authenticate(params[:session][:password])
        self.logged_user = user
        set_autologin_cookie(user)
        redirect_to books_path
        unless user.admin?
          welcome_message = "Welcome, #{user.name}"
        else
          welcome_message = "Admin privileges granted. With great power comes great responsibility."
        end
        flash[:notice] = welcome_message
      elsif user == nil
        flash[:danger] = "User not found"
        render 'login'
      else
        flash.now[:danger] = "Oops! It looks like you may have forgotten your password. #{view_context.link_to "Click here to reset it.", lost_password_path}".html_safe
        render 'login'
      end
    end
  end

  def set_autologin_cookie(user)
    token = user.generate_autologin_token
    cookies['autologin'] = {
      :value => token,
      :expires => 1.year.from_now,
      :httponly => true
    }   
  end

  def logout
    redirect_to root_path if request.get?
    if User.current.anonymous?
      redirect_to root_url
    elsif request.post?
      logout_user
      redirect_to root_url
    end
  end

  def signup
    @user = User.new
    if request.post?
      @user = User.new(user_params)
      if @user.save
        MailerWorker.perform_async(params[:user][:name], params[:user][:email])
        flash[:notice] = "Welcome email sent to #{@user.email}."\
            "If you don't see this email in your inbox within 15 minutes, look for it in your junk mail folder."\
            "If you find it there, please mark the email as 'Not Junk'."
        redirect_to root_path 
      else 
        render 'signup'
      end
    end
  end

  def account
    if !User.current.logged?
      render_403
      return
    else 
      @user = User.find_by_email(User.current.email)
      if request.post?
        if @user.update_attributes(user_params)
          unless User.current.admin?
            redirect_to account_path, :flash => { :success => "User was successfully updated!" }
          else 
            redirect_to users_path, :flash => { :success => "User was successfully updated!" }
          end
        else
          render 'edit'
        end
      end
    end
  end

  def lost_password
    if request.post?  
      @user = User.find_by_email(params[:password_reset][:email])
      if @user
        token = Token.create!(:user_id => @user.id, :action => 'password_recovery')
        @user.save!
        PasswordResetWorker.perform_async(@user.name, @user.email, token.value)
        redirect_to root_url
        flash[:info] = "Email sent with password reset instructions to #{@user.email}"
      else
        redirect_to root_path, :flash => { :error => "No users found with following email #{params[:password_reset][:email]}" }
      end
    end
  end

  def password_recovery
    token = Token.find_by(value: params[:id], action: 'password_recovery')
    if token 
      @user = Token.find_user(token.value)
      if request.patch?
        if !token.expired? and @user 
          if @user.update_attributes(user_params)
            redirect_to root_path, :notice => "Password has been reset."
          end
        else 
          redirect_to root_path, :flash => { :error => "Password reset token has expired." }
        end
      end
    else
      render_404
    end
  end

  def destroy
    if !User.current.logged?
      render_403
      return
    else 
      @user = User.find_by_email(User.current.email)
      @user.destroy
      reset_session
      redirect_to root_path, :flash => { :success => "Your account was terminated" }
    end
  end

  private

    def redirect_if_logged
      redirect_to root_path if User.current.logged?
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
