class Admin::AuthorsControllerTest < ActionDispatch::IntegrationTest
   
    def setup 
        @admin = users(:admin)
        log_user(@admin.email, 'secret')
    end

    test "should create author" do
        get '/authors/new'
        assert_response :success
    
        post '/authors', params: { 
          author: {
            first_name: 'steven',
            last_name: 'king'
          }
        }
        author = Author.find_by_first_name('steven')
        assert_kind_of Author, author
    end

    test "should delete author" do 
        author = authors(:carnegie)
        assert author
        assert_difference 'Author.count', -1 do
            delete author_path(author)
        end

        author = Author.find_by_first_name("Dale")
        assert_nil author
    end


    test "should update author" do 
        author = authors(:carnegie)
        patch author_path(author), params: { 
            author: {
              first_name: 'daniel',
              last_name: 'kahneman'
            }
        }
        assert_response :redirect
        follow_redirect!
    
        author = Author.find_by_first_name('daniel')
        assert_equal 'daniel', author.first_name
        assert_equal 'kahneman', author.last_name
    end
end  