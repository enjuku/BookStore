User.create(
    name: "admin",
    email: "admin@mail.com",
    password: "123456",
    password_confirmation: "123456",
    admin: true
)

User.create(
    name: "user",
    email: "user@mail.com",
    password: "123456",
    password_confirmation: "123456"
)


authors = {0 => ["Franz", "Kafka"], 1 => ["Ernest", "Hemingway"], 2 => ["Dale", "Carnegie"]}

genres = ["Non-fiction", "Realism", "Short story", "Novel"]

4.times do |i|

    Genre.create(
        name: genres[i],
        created_at: DateTime.now.to_date, 
        updated_at: DateTime.now.to_date)

    if i < 3 
        Author.create(
            first_name: authors[i].first, 
            last_name: authors[i].last, 
            created_at: DateTime.now.to_date, 
            updated_at: DateTime.now.to_date)
    end
end

book_titles = ["How to Win Friends and Influence People", "A Farewell to Arms", "In the Penal Colony", "The Castle", "The Trial"]

book_titles.each_with_index do |title, index|
    case index
    when 0
        au = Author.find_by(last_name: 'Carnegie')
        ge = Genre.find_by(name: 'Non-fiction')
    when 1
        au = Author.find_by(last_name: 'Hemingway')
        ge = Genre.find_by(name: 'Realism')
    when 2
        au = Author.find_by(last_name: 'Kafka' )
        ge = Genre.find_by(name: 'Short story')
    when 3
        au = Author.find_by(last_name: 'Kafka') 
        ge = Genre.find_by(name: 'Novel')
    when 4
        au = Author.find_by(last_name: 'Kafka')
        ge = Genre.find_by(name: 'Short story')
    end

    Book.create(
        author: au,
        genres: [ge],
        title: title,
        description: "......",
        created_at: DateTime.now.to_date, 
        updated_at: DateTime.now.to_date,
        book_img: File.open(File.join(Rails.root,"app/assets/images/#{index+1}.jpg")))
end
