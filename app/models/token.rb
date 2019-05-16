class Token < ActiveRecord::Base

  belongs_to :user

  validates :value, 
        :presence => true,
        :uniqueness => true

  before_validation :delete_previous_tokens, :generate_new_token

  VALIDITY_TIME = {
    'autologin'         => 1.year,
    'session'           => nil,
    'password_recovery' => 1.day
  }

  def generate_new_token
    loop do 
      self.value = SecureRandom.urlsafe_base64(50)
      break if !Token.find_user(self.value)
    end
  end

  def expired?
    if VALIDITY_TIME[self.action]
      created_at + VALIDITY_TIME[self.action] < Time.now.utc
    end
  end

  def delete_previous_tokens
    if user
      scope = Token.where(:user_id => user.id, :action => action)
      scope.delete_all
    end
  end

  def self.find_user(value)
    token = Token.find_by(:value => value)
    if token 
      token.user
    else 
      nil
    end
  end

  def self.destroy_expired
    Token.all.each do |t| 
      if t.expired? 
        t.delete 
      end
    end
  end

end
