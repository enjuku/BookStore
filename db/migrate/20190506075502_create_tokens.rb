class CreateTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :tokens do |t|
      t.column "user_id", :integer, :default => 0, :null => false
      t.column "action", :string, :limit => 30, :default => "", :null => false
      t.column "value", :string, :limit => 40, :default => "", :null => false

      t.timestamps
    end
  end
end
