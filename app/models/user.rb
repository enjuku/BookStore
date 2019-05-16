require 'bcrypt'

class User < ApplicationRecord
  include BCrypt
  has_secure_password

  validates :name,
    :uniqueness => {:message => "User name already taken."},
    :presence => {:message => "User name can't be balnk."}

  validates :email,
    :uniqueness => {:message => "E-mail has already taken."},
    :presence => {:message => "E-mail can't be balnk."}

  validates :password, 
    :confirmation => true,
    :allow_nil => true,
    :presence => {:message => "Password can't be blank."},
    :length => {:within => 6..20, 
                :too_long => "Must be less than 20 characters",
                :too_short => "Must be more than 6 characters"}
  
  def generate_autologin_token
    token = Token.create!(:user_id => id, :action => 'autologin')
    token.value
  end

  def delete_autologin_token(value)
    Token.where(:user_id => id, :action => 'autologin', :value => value).delete_all
  end

  def generate_session_token
    token = Token.create!(:user_id => id, :action => 'session')
    token.value
  end

  def delete_session_token(value)
    Token.where(:user_id => id, :action => 'session', :value => value).delete_all
  end

  def self.current=(user)
    RequestStore.store[:current_user] = user
  end

  def self.current
    RequestStore.store[:current_user] ||= User.anonymous
  end

  def self.try_to_autologin(value)
    token = Token.find_by(value: value, action: 'autologin')
    if token
      user = Token.find_user(token.value)
      if user
        user
      end
    end
  end

  def logged?
    true
  end

  def anonymous?
    !logged?
  end

  def self.anonymous
    AnonymousUser.create
  end
  
end


class AnonymousUser < User

  def logged?; false end

end