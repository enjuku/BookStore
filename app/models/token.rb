class Token < ActiveRecord::Base

  belongs_to :user

  validates :value, 
        :presence => true,
        :uniqueness => true

  # before_create :delete_previous_tokens, :generate_new_token

  before_validation :delete_previous_tokens, :generate_new_token

  cattr_accessor :validity_time

  self.validity_time = 1.day

  # def self.generate_token_value
  #   self.value
  # end

  def generate_new_token
    loop do 
      # self.value = Random.new.rand(1..2)
      self.value = SecureRandom.urlsafe_base64(50)
      break if !Token.find_user(self.value)
    end
  end

  def expired?
    created_at + validity_time < Time.now.utc
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

end