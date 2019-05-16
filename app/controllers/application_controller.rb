class ApplicationController < ActionController::Base

  before_action :user_setup

  include UsersHelper

  def user_setup
    User.current = find_current_user
  end

  def find_current_user
    user = nil
    if session[:user_id]
      user = User.find(session[:user_id])
    elsif autologin_user = try_to_autologin
      user = autologin_user
    else 
      user = User.anonymous
    end
    user
  end

  def logged_user=(user)
    reset_session
    if user && user.is_a?(User)
      User.current = user
      start_user_session(user)
    end
  end

  def try_to_autologin
    if cookies['autologin']
      user = User.try_to_autologin(cookies['autologin'])
      if user
        reset_session
        start_user_session(user)
      end
      user
    end
  end

  def start_user_session(user)
    session[:user_id] = user.id
    session[:token] = user.generate_session_token
  end

  def logout_user
    if User.current.logged?
      if autologin = cookies.delete('autologin')
        User.current.delete_autologin_token(autologin)
      end
      User.current.delete_session_token(session[:token])
      self.logged_user = nil
    end
  end

  def render_403
    @status = 403
    @message = "You don't have access to view this page." 
    render :template => 'common/403', :status => @status, :message => @message 
  end

  def render_404
    @status = 404
    @message = "The page you were looking for doesn't exist
                You may have mistyped the address or the page may have moved
                If you are the application owner check the logs for more information."
    render :template => 'common/404', :status => @status, :message => @message 
  end

  def require_login
    if !User.current.logged?
      render_403
      return false
    end
    true
  end

  def require_admin
    return unless require_login
    if !User.current.admin?
      render_403
      return false
    end
    true
  end

end
