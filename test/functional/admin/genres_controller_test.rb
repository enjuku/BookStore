class Admin::GenresControllerTest < ActionDispatch::IntegrationTest

    def setup 
        @admin = users(:admin)
        log_user(@admin.email, 'secret')
    end

    test "should create genre" do
        get '/genres/new'
        assert_response :success
    
        post '/genres', params: { 
          genre: {
            name: 'sci-fi',
          }
        }
        genre = Genre.find_by_name('sci-fi')
        assert_kind_of Genre, genre
    end

    test "should delete genre" do 
        genre = genres(:realism)
        assert genre
        assert_difference 'Genre.count', -1 do
            delete genre_path(genre)
        end

        genre = Genre.find_by_name("Realism")
        assert_nil genre
    end


    test "should update genre" do 
        genre = genres(:realism)
        patch genre_path(genre), params: { 
            genre: {
              name: 'novel'
            }
        }
        assert_response :redirect
        follow_redirect!
    
        genre = Genre.find_by_name('novel')
        assert_equal 'novel', genre.name
    end
  
end