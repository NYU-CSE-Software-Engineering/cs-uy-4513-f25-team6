class CreateDoctors < ActiveRecord::Migration[8.0]
    def change
      create_table :doctors do |t|
        t.string :email
        t.string :username
        t.string :password
        t.belongs_to :clinic
        t.float :salary
        t.string :specialty
        t.string :phone
        t.timestamps
      end
    end
  end
  