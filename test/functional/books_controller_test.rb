require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest

  def setup 
    @book = books(:bookone)
    @admin = users(:admin)
    @genre = genres(:nonfiction)
    @othergenre = genres(:realism)
    @otherauthor = authors(:kafka)
    log_user(@admin.email, 'secret')
  end

  test "should create new book" do 
    get '/books/new'
    assert_response :success

    post '/books', params: { 
      book: {
        title:  'titleofnewbook',
        author_id: @book.author_id,
        genre_ids: [@genre.id],
        description: '--------------------------',
        book_img:  Rack::Test::UploadedFile.new('app/assets/images/1.jpg', 'image/jpg')
      }
    }

    book = Book.find_by_title('titleofnewbook')
    assert_kind_of Book, book
  end

  test "should delete book" do 
    book = Book.find_by_title("How to win friends and infuence people")
    assert book

    assert_difference 'Book.count', -1 do
      delete book_path(@book)
    end
    book = Book.find_by_title("How to win friends and infuence people")
    assert_nil book
  end

  test "should update book" do 
    patch book_path(@book), params: { 
      book: {
        title:  'newtitle',
        author_id: @otherauthor.id,
        genre_ids: [@othergenre.id],
        description: 'newdescription'
      }
    }
    assert_response :redirect
    follow_redirect!

    book = Book.find_by_title('newtitle')
    assert_equal 'newtitle', book.title
    assert_equal 'Franz', book.author.first_name
    assert_equal 'Realism', book.genres.first.name
    assert_equal 'newdescription', book.description

  end

end
