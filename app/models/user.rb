require 'bcrypt'

class User < ApplicationRecord
  include BCrypt
  has_secure_password

  # accepts_nested_attributes_for :password_resets
  # before_create { generate_token(:auth_token) }

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
  
  # validates :token, presence: true, uniqueness: true, strict: TokenGenerationException

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
    # anonymous_user = AnonymousUser.unscoped.find_by(:lastname => 'Anonymous')
    # if anonymous_user.nil?
    #   anonymous_user = AnonymousUser.unscoped.create(:lastname => 'Anonymous', :firstname => '', :login => '', :status => 0)
    #   raise 'Unable to create the anonymous user.' if anonymous_user.new_record?
    # end
    # anonymous_user
    AnonymousUser.create(name: "Anonymous")
  end
  
end

class AnonymousUser < User
  validate :validate_anonymous_uniqueness, :on => :create

  def logged?; false end
  # def admin; false end

  def validate_anonymous_uniqueness
    # There should be only one AnonymousUser in the database
    # puts "#{AnonymousUser.exists?}"
    # errors.add :base, 'An anonymous user already exists.' if AnonymousUser.exists?
  end

end