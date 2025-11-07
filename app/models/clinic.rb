class Clinic < ApplicationRecord
    has_many :doctors

    # name is required
    validates :name, presence: true
    # name must be unique (case-insensitive)
    validates :name, uniqueness: { case_sensitive: false }
    # rating must be between 0.0 and 5.0 if present
    validates :rating, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 5.0 }, allow_nil: true
end

