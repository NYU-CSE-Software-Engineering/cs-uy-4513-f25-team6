class DoctorsController < ApplicationController

    before_action :require_login, except: [:new, :create]
    
    # GET /doctors/new
    # Shows the doctor registration form
    def new
    end

    # POST /doctors
    # Creates a new doctor account
    def create
        begin
            filtered = params.expect(doctor: [:email, :username, :password, :specialty, :phone])
        rescue ActionController::ParameterMissing
            flash[:alert] = 'Missing required information'
            render :new
            return
        end

        filtered[:password] = Digest::MD5.hexdigest(filtered[:password])
        @new_doctor = Doctor.new(filtered)

        if (@new_doctor.valid?)
            @new_doctor.save
            session[:user_id] = @new_doctor.id
            session[:role] = 'doctor'
            flash[:notice] = 'Doctor account created'
            redirect_to doctor_dashboard_path
            return
        else
            flash[:alert] = 'Invalid account details: '+@new_doctor.errors.full_messages.to_s
            render :new
            return
        end
    end
    
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