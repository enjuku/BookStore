class Admin::GenresController < ApplicationController
    
    before_action :require_admin
    before_action :find_genre, only: [:show, :edit, :update, :destroy]

    def index
        @genres = Genre.all
    end

    def new 
        @genre = Genre.new
    end

    def create
        @genre = Genre.new(genre_params)
    
        if @genre.save
          redirect_to genres_path
        else 
          render 'new'
        end
    end

    def edit 
    end

    def update
        unless @genre.update_attributes(genre_params)
            redirect_to edit_genre_path, :flash => { :error => "Genre was not updated! Not all required fields were filled." }
        else
            redirect_to genres_path, :flash => { :success => "Genre successfully updated!" }
        end
    end

    def destroy
        @genre.destroy
        redirect_to genres_path
    end

    private

        def genre_params
            params.require(:genre).permit(:name) 
        end

        def find_genre
            @genre = Genre.find(params[:id])
        end
end
