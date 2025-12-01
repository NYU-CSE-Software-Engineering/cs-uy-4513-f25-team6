class Doctor < User
    belongs_to :clinic, optional: true
    has_many :time_slots, -> { order(:starts_at) }
    has_many :appointments, through: :time_slots


    # Search for doctors within a specific clinic by name and/or specialty
    # @param name [String] the doctor's name (partial match, case-insensitive)
    # @param specialty [String] the doctor's specialty (exact match, case-insensitive)
    # @param clinic_id [Integer] the clinic ID to search within
    # @return [ActiveRecord::Relation] matching doctors
    def self.search_doctor(name, specialty, clinic_id)
        # Start with doctors in the specified clinic
        doctors = where(clinic_id: clinic_id)

        # Filter by name if provided (partial match using LIKE)
        if name.present?
            normalized_name = name.to_s.strip.downcase
            doctors = doctors.where("LOWER(username) LIKE ?", "%#{normalized_name}%")
        end

        # Filter by specialty if provided (exact match)
        if specialty.present?
            normalized_specialty = specialty.to_s.strip.downcase
            doctors = doctors.where("LOWER(specialty) = ?", normalized_specialty)
        end

        doctors
    end


    # Get all doctors in a clinic sorted by rating in descending order
    # Doctors with nil ratings are placed last
    # @param clinic_id [Integer] the clinic ID to filter by
    # @return [ActiveRecord::Relation] doctors sorted by rating (highest first)
    def self.sort_by_rating(clinic_id)
        where(clinic_id: clinic_id).order(Arel.sql('rating DESC NULLS LAST'))
    end


    # Get all doctors belonging to a specific clinic
    # @param clinic_id [Integer] the clinic ID to filter by
    # @return [ActiveRecord::Relation] all doctors in the clinic
    def self.doctors_in_clinic(clinic_id)
        where(clinic_id: clinic_id)
    end

end