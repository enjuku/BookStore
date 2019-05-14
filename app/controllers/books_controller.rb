class BooksController < ApplicationController    

    before_action :require_login
    before_action :require_admin, only: [:edit, :update, :destroy]    
    before_action :find_book,     only: [:show, :edit, :update, :destroy]

    def index
        @books = Book.eager_load(:author, :genres).search(params[:search])
    end

    def show 
    end

    def new
        @book = Book.new 
    end

    def create
        @book = Book.new(book_params)

        if @book.save
          redirect_to books_path
        else 
          render 'new'
        end
    end

    def edit 
    end

    def update
        unless @book.update_attributes(book_params)
            redirect_to edit_book_path, :flash => { :error => "Book was not updated! Not all required fields were filled or image parameters are incorrect." }
        else
            redirect_to books_path, :flash => { :success => "Book successfully updated!" }
        end
    end

    def destroy
		@book.destroy
		redirect_to root_path
    end

    private

        def book_params
            params.require(:book).permit(:title, :description, :book_img, :author_id, genre_ids:[])
        end

        def find_book
            @book = Book.find(params[:id])
        end

end