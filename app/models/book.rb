class Book < ApplicationRecord

    belongs_to :author
    has_and_belongs_to_many :genres
    
    has_attached_file :book_img, styles: { book_index: "250x350>", book_show: "325x475>" }, default_url: "/images/:style/missing.png"

    validates_attachment :book_img,
        presence: { message: "Book cover can't be blank"},
        content_type: { :content_type => ['image/jpeg', 'image/png'] },
        size: { in: 0..500.kilobytes }

    validates_associated :author, :genres, presence: true

    validates :title, :description, :genres, presence: true

    private 

        def self.search(query)
            unless query
                all
            else 
                query = query.delete "\s\n"

                where("(authors.first_name || authors.last_name) LIKE :q
                        OR authors.first_name LIKE :q 
                        OR authors.last_name LIKE :q 
                        OR genres.name LIKE :q 
                        OR title LIKE :q",
                        :q => "%#{query}%")
            end
        end
end
