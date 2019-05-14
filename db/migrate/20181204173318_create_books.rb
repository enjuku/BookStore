class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.references :author, index: true

      t.timestamps
    end
  end
end