class DoctorsController < ApplicationController
    before_action(only: [:update]) { check_login ['doctor'] }
    
    # GET /clinics/:clinic_id/doctors
    # Lists all doctors within a specific clinic
    def index
        @clinic = Clinic.find(params[:clinic_id])
        @specialties = @clinic.doctors.pluck(:specialty)

        if params[:specialty] && params[:specialty] != ""
            @doctors = @clinic.doctors.where(specialty: params[:specialty])
        else
            @doctors = @clinic.doctors
        end

        if params[:sort] == "rating"
            @doctors = @doctors.order(rating: :desc)
        end
    end

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

    # PATCH /clinics/:clinic_id/doctors/:id
    # Associates a clinic with a doctor
    def update
        doctor = Doctor.find(params[:id])
        clinic = Clinic.find(params[:clinic_id])

        if doctor.clinic == clinic
            flash[:alert] = "You are already employed at this clinic"
            else
            if doctor.update(clinic: clinic)
                flash[:notice] = "You are now employed at #{clinic.name}"
            else
                flash[:alert] = "Unable to sign up for clinic"
            end
        end

        redirect_to clinics_path
    end

    # GET /clinics/:clinic_id/doctors/search
    # Searches for doctors within a specific clinic by name and/or specialty
    # def search
    #     @clinic = Clinic.find(params[:clinic_id])

    #     # Get the search parameters from the HTTP request
    #     name = params[:name]
    #     specialty = params[:specialty]
    #     sort = params[:sort]

    #     # Check if sorting by rating is requested
    #     if sort == "rating"
    #         @doctors = Doctor.sort_by_rating(@clinic.id)
    #         return
    #     end

    #     # Check that at least one search parameter is present
    #     if name.blank? && specialty.blank?
    #         flash[:error] = "Please provide at least a name or specialty to search"
    #         @doctors = Doctor.none
    #         return
    #     end

    #     # Use the model's search method
    #     @doctors = Doctor.search_doctor(name, specialty, @clinic.id)

    #     # Show error if no doctors found
    #     if @doctors.empty?
    #         flash[:error] = "No doctors found matching your search criteria"
    #     end
    # end   
end
