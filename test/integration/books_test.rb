require 'test_helper'

class BooksTest < ActionDispatch::IntegrationTest

  def setup 
    @book = books(:bookone)
    @user = users(:user)
    @genre = genres(:nonfiction)
    log_user(@user.email, 'secret')
    get '/books'
  end
    
  test 'should find title' do
    query = "win"
    res = Book.eager_load(:author, :genres).search(query)
    assert_select "p.title", { :count => 1, :html => /#{query}/ }
  end

  test 'should find author' do
    query = "Dale"
    res = Book.eager_load(:author, :genres).search(query)
    assert_select "p.author", { :count => 1, :html => /#{query}/ }
  end

  test 'should find genre' do
    query = "fict"
    res = Book.eager_load(:author, :genres).search(query)
    assert_select "p.genres",  { :count => 1, :html => /#{query}/ }
  end

  test 'should not find anything' do
    query = "__/"
    res = Book.eager_load(:author, :genres).search(query)
    assert_select "p.author", { :count => 0, :html => /#{query}/ }
    assert_select "p.title", { :count => 0, :html => /#{query}/ }
    assert_select "p.genres", { :count => 0, :html => /#{query}/ }
  end

end
