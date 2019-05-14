class Admin::AuthorsController < ApplicationController
    
    before_action :require_admin
    before_action :find_author, only: [:show, :edit, :update, :destroy]

    def index
        # @authors = Author.eager_load(:books)
        @authors = Author.all
    end

    def new 
        @author = Author.new
    end

    def create
        @author = Author.new(author_params)
    
        if @author.save
          redirect_to authors_path
        else 
          render 'new'
        end
    end

    def edit 
    end

    def update
        unless @author.update_attributes(author_params)
            redirect_to edit_author_path, :flash => { :error => "Author was not updated! Not all required fields were filled." }
        else
            redirect_to authors_path, :flash => { :success => "Author successfully updated!" }
        end
    end

    def destroy
        @author.destroy
        redirect_to authors_path
    end

    private

        def author_params
            params.require(:author).permit(:first_name, :last_name) 
        end

        def find_author
            @author = Author.find(params[:id])
        end
end
