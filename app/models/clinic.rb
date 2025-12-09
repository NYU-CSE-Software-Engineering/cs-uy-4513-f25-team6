class Clinic < ApplicationRecord # start of Clinic model
    has_many :doctors

    validates :name, :specialty, :location, :rating, presence: true # all fields required
    validates :name, uniqueness: { case_sensitive: false }  # name must be unique (case-insensitive)
    validates :rating, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0 }, allow_nil: true # rating must be between 0.0 and 5.0 if present

    
    def self.search_clinic(specialty, location) # start of search_clinic method definition
        
        clinics = all # start with all clinics
                         # SELECT * FROM clinics
        
        if specialty.present?
           normalized_specialty = specialty.to_s.strip.downcase
           clinics = clinics.where("LOWER(specialty) = ?", normalized_specialty)
        end
        
        if location.present?
            normalized_location = location.to_s.strip.downcase
            clinics = clinics.where("LOWER(location) = ?", normalized_location)
        end

        clinics # return the filtered clinics

    end # end of search_clinic method defn.


    def self.sort_by_rating # start of sort_by_rating method definition
        order(Arel.sql('rating DESC NULLS LAST'))
    end # end of sort_by_rating method defn.


end # end of Clinic model








