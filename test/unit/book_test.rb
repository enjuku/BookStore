require 'test_helper'

class BookTest < ActiveSupport::TestCase

    def setup 
        @genre = genres(:realism)
        @author = authors(:kafka)
    end

    test "should create" do
        book = Book.new(
            title:  'newtitle',
            author_id: @author.id,
            genre_ids: [@genre.id],
            description: 'newdescription',
            book_img:  Rack::Test::UploadedFile.new('app/assets/images/1.jpg', 'image/jpg'))
        assert book.valid?
    end

    test "should not create without author" do
        book = Book.new(
            title:  'newtitle',
            genre_ids: [@genre.id],
            description: 'newdescription',
            book_img:  Rack::Test::UploadedFile.new('app/assets/images/1.jpg', 'image/jpg'))
        assert_not book.valid?
    end

    test "should not create without genres" do
        book = Book.new(
            title:  'newtitle',
            author_id: @author.id,
            description: 'newdescription',
            book_img:  Rack::Test::UploadedFile.new('app/assets/images/1.jpg', 'image/jpg'))
        assert_not book.valid?
    end

    test "should not create without cover image" do
        book = Book.new(
            title:  'newtitle',
            author_id: @author.id,
            genre_ids: [@genre.id],
            description: 'newdescription')
        assert_not book.valid?
    end
    
end

