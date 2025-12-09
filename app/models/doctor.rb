class Doctor < User
    belongs_to :clinic, optional: true
    has_many :time_slots, -> { order(:starts_at) }
    has_many :appointments, through: :time_slots
    has_many :prescriptions
end