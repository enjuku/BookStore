require 'test_helper'

class UsersTest < ActionDispatch::IntegrationTest

    def setup
        @user = users(:user)
    end

    test "should sign up" do 
        get '/signup'
        post '/signup', params:{
            user:{
                name: "hippo",
                email: "mymail@mail.com" ,
                password: 'securepass',
                password_confirmation: 'securepass'
            }
        }
        assert_response :redirect
        follow_redirect!
        user = User.find_by_email("mymail@mail.com")
        assert_select '.alert_message', text: "Welcome email sent to #{user.email}."\
                                                "If you don't see this email in your inbox within 15 minutes, look for it in your junk mail folder."\
                                                "If you find it there, please mark the email as 'Not Junk'." 
    end

    test "should not sign up with password mismatch" do 
        get '/signup'
        post '/signup', params:{
            user:{
                name: "hippo",
                email: "a@mailcom" ,
                password: 'securepass',
                password_confirmation: 'securepass123456789'
            }
        }
        assert_template "users/signup"
    end

    test "should edit user" do 
        log_user(@user.email, 'secret')
        post '/account', params: { 
            user: {
                name: 'newname',
            }
        }
        user = User.find_by_name("newname")
        assert_equal user.name, 'newname'
    end

    test "should display message if user not found" do 
        log_user('fromnowhere@mail.com', '123456')
        assert_select '.alert_message', text: "User not found"
    end

    test "should offer to reset password" do 
        log_user(@user.email, 'wrong password')                
        assert_select '.alert_message', text: "Oops! It looks like you may have forgotten your password. Click here to reset it."
    end

    test "login should set session token" do
        assert_difference 'Token.count', 2 do
            log_user(@user.email, 'secret')
            assert_equal 2, session[:user_id]
            assert_not_nil session[:token]
        end
    end

    test "should not send password reset email when user not found" do 
        PasswordResetWorker.clear
        get lost_password_path
        post lost_password_path, params: { 
            password_reset: { 
                email: 'nonexistent@mail.com' 
            }
        }
        assert_response :redirect
        follow_redirect!
        assert_select '.alert_message', text: "No users found with following email nonexistent@mail.com"
        assert_equal 0, PasswordResetWorker.jobs.size
    end

    test "should not reset password with expired token" do
        get lost_password_path
        post lost_password_path, params: { 
            password_reset: { 
                email: @user.email 
            }
        }
      
        assert_response :redirect
        follow_redirect!
        assert_select '.alert_message', text: "Email sent with password reset instructions to #{@user.email}"

        token = Token.find_by(user_id: @user.id, action: 'password_recovery')
        token.update_attribute(:created_at, 30.hours.ago)

        get password_recovery_path(token.value)
        patch password_recovery_path(token.value),
              params: { email: @user.email,
                        user: { password:              "newpass",
                                password_confirmation: "newpass" } }
        assert_response :redirect
        follow_redirect!
        assert_select '.alert_message', text: "Password reset token has expired."
    end

    test "should change password and signin with new password" do
        NEW_PASSWORD = "newpassword"

        get lost_password_path
        post lost_password_path, params: { 
            password_reset: { 
                email: @user.email 
            }
        }

        token = Token.find_by(user_id: @user.id, action: 'password_recovery')

        get password_recovery_path(token.value)
        patch password_recovery_path(token.value),
            params: { 
                user: { 
                    password:              NEW_PASSWORD,
                    password_confirmation: NEW_PASSWORD 
                }
            }

        assert_response :redirect
        follow_redirect!
        assert_select '.alert_message', text: "Password has been reset."

        get login_path
                            
        post login_path, params: { 
            session: {
                email: @user.email,
                password: NEW_PASSWORD,
            }
        }
        assert_response :redirect
        follow_redirect!
    end

    test "should destroy account" do 
        log_user(@user.email, 'secret')
        get '/account'
        post '/account/destroy'
        user = User.find_by_name("Johnny")
        assert_nil user
    end

    test "autologin after session reset" do 
        post '/login', params:{session:{email:@user.email,password: 'secret'}}
        token = Token.find_by(user_id: @user.id, action: 'autologin')

        reset!
        
        cookies[:autologin] = token.value
        get '/books'
        assert_equal @user.id, session[:user_id]
    end

end