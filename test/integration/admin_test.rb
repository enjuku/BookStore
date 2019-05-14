class AdminTest < ActionDispatch::IntegrationTest

    def setup 
        @admin = users(:admin)
        log_user(@admin.email, 'secret')
    end

    test 'add user' do
        get '/users'
        assert_response :success

        get '/users/new'
        assert_response :success
    
        post '/users', params: { 
            user: {
                name: 'newjdoe',
                email: 'newjdoe123@mail.com',
                password: 'jdoe123',
                password_confirmation: 'jdoe123' 
            }
        }
        user = User.find_by_name("newjdoe")
        assert_kind_of User, user
    end

    test 'edit user' do 
        get '/users/2/edit'
        assert_response :success

        patch user_path(2), params: { 
            user: {
                name: 'jdoe',
                email: 'jdoe123@mail.com',
                password: 'jdoe123',
                password_confirmation: 'jdoe123' 
            }
        }
        user = User.find_by_name("jdoe")
        assert_kind_of User, user
    end

    test 'destroy user' do 
        delete user_path(2)
        user = User.find_by_name("Johnny")
        assert_nil user
    end

end