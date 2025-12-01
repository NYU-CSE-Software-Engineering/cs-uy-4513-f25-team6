# This is for RESTful doctor pages (nested under clinics)

class DoctorsController < ApplicationController

    before_action :require_login


    # GET /clinics/:clinic_id/doctors
    # Lists all doctors within a specific clinic
    def index
        @clinic = Clinic.find(params[:clinic_id])
        @doctors = @clinic.doctors
    end


    # GET /clinics/:clinic_id/doctors/search
    # Searches for doctors within a specific clinic by name and/or specialty
    def search
        @clinic = Clinic.find(params[:clinic_id])

        # Get the search parameters from the HTTP request
        name = params[:name]
        specialty = params[:specialty]
        sort = params[:sort]

        # Check if sorting by rating is requested
        if sort == "rating"
            @doctors = Doctor.sort_by_rating(@clinic.id)
            return
        end

        # Check that at least one search parameter is present
        if name.blank? && specialty.blank?
            flash[:error] = "Please provide at least a name or specialty to search"
            @doctors = Doctor.none
            return
        end

        # Use the model's search method
        @doctors = Doctor.search_doctor(name, specialty, @clinic.id)

        # Show error if no doctors found
        if @doctors.empty?
            flash[:error] = "No doctors found matching your search criteria"
        end
    end


    private

    # Redirects to login page if user is not signed in
    def require_login
        unless session[:user_id]
            redirect_to login_path
        end
    end

end