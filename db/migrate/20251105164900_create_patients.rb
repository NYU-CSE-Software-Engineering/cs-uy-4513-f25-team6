class CreatePatients < ActiveRecord::Migration[8.0]
    def change
      create_table :patients do |t|
        t.string :email
        t.string :username
        t.string :password
        t.integer :age
        t.float :height
        t.float :weight
        t.string :gender
        t.text :notes
        t.timestamps
      end
    end
  end
  