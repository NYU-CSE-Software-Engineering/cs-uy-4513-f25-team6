class ClinicsController < ApplicationController
    before_action { check_login ['patient', 'doctor', 'admin'] }
    before_action(only: [:create]) { check_login ['admin'] }

    def create
        clinParams = params.expect(clinic: [:name, :specialty, :location, :rating])
        newClin = Clinic.new(clinParams)
        if newClin.valid?
            newClin.save
            flash[:notice] = "New clinic created"
        else
            if newClin.errors.full_messages.include?("Name has already been taken")
                flash[:alert] = "A clinic with that name already exists"
            else
                flash[:alert] = "Missing required data"
            end
        end
        redirect_to admin_dashboard_path
    end

    def index
        @clinics = Clinic.order(:name) # grab all Clinics from the database and order them by name

        # no explicity redirect so this action will render the index template: app/views/clinics/index.html.erb
    end


    def search
        # get the search parameters from the http request
        specialty = params[:specialty]
        location = params[:location]
        sort = params[:sort]

        # check if sorting by rating is requested
        if sort == "rating"
            @clinics = Clinic.sort_by_rating # use the model's sort_by_rating method
            return
        end

        # check that at least one search parameter is present
        if specialty.blank? && location.blank?
            flash[:alert] = "Please provide at least a specialty or location to search"
            @clinics = Clinic.none
            return
        end

        # use the model's search method
        @clinics = Clinic.search_clinic(specialty, location)
    end


    private

    def require_login
        unless session[:user_id]
            redirect_to login_path # redirect to the login page if the user is not logged in
        end
    end


end


