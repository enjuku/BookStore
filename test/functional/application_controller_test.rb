class ApplicationControllerTest < ActionDispatch::IntegrationTest

    test "require user to access section" do 
        [ '/account', '/books' ].each do |page|
            get page
            assert_select "#errorExplanation", "You don't have access to view this page."
        end
    end

    test "require admin to access section" do 
        @user = users(:user)
        log_user(@user.email, 'secret')
        [ '/users', '/users/1/edit', '/authors',
          '/genres', '/genres/1/edit', '/books/1/edit' ].each do |page|
            get page
            assert_select "#errorExplanation", "You don't have access to view this page."
        end
    end

    test "test 404 error" do 
        get '/acco'
        assert_select "#errorExplanation", "The page you were looking for doesn't exist
                You may have mistyped the address or the page may have moved
                If you are the application owner check the logs for more information."
    end

end