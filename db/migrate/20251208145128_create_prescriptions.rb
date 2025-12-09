class CreatePrescriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :prescriptions do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :doctor, null: false, foreign_key: true
      t.string :medication_name, null: false
      t.string :dosage
      t.text :instructions
      t.date :issued_on, null: false
      t.string :status, null: false, default: 'active'

      t.timestamps
    end

    add_index :prescriptions, [:patient_id, :issued_on]
  end
end
