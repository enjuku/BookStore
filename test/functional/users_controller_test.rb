require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  test 'get signup' do 
    get '/signup'
    
    assert_select 'form' do
      assert_select 'input#user_name'
      assert_select 'input#user_email'
      assert_select 'input#user_password'
      assert_select 'input#user_password_confirmation'
    end
  end

  test 'get signup when logged should redirect to home by default' do
    @user = users(:user)
    log_user(@user.email, 'secret')
    get '/signup'
    assert_redirected_to '/'
  end

  test 'get login' do
    get '/login'

    assert_select 'form' do
      assert_select 'input#session_email'
      assert_select 'input#session_password'
    end
  end

  test 'get logout' do
    @user = users(:user)
    log_user(@user.email, 'secret')
    post '/logout'
    assert_redirected_to '/'
    assert_nil session[:user_id]
  end

  test 'get logout when not logged should redirect to home by default' do
    post '/logout'
    assert_redirected_to '/'
  end

  test 'get lost password' do
    get '/lost_password'
    assert_response :success
    assert_select 'input#password_reset_email'
  end

  test 'get account' do 
    @user = users(:user)
    log_user(@user.email, 'secret')
    get '/account'
    assert_response :success
  end

end
