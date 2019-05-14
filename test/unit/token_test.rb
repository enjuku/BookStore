require 'test_helper'

class TokenTest < ActiveSupport::TestCase

    def setup 
        @user = users(:user)
    end

    test "should generate token" do 
        token = Token.create!(:user_id => @user.id, :action => 'password_recovery')
        user = Token.find_user(token.value)
        assert !token.expired?
        assert_equal user.id, token.user_id
    end

    test "create should remove existing tokens" do
        t1 = Token.create!(:user_id => @user.id, :action => 'password_recovery')
        t2 = Token.create!(:user_id => @user.id, :action => 'password_recovery')
        assert_not_equal t1.value, t2.value
        assert !Token.exists?(t1.id)
        assert  Token.exists?(t2.id)
    end
end