class CreateBills < ActiveRecord::Migration[8.0]
  def change
    create_table :bills do |t|
      t.belongs_to :patient, null: false
      t.belongs_to :appointment, null: false
      t.integer :amount_cents, null: false
      t.string :status, null: false, default: 'unpaid'
      t.datetime :paid_at
      t.timestamps
    end

    add_index :bills, :status
    add_index :bills, :paid_at
    add_index :bills, :appointment_id, unique: true
  end
end
