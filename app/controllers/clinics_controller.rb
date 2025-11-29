class ClinicsController < ApplicationController
    
    before_action :require_login

    def index # start of the #index action in the ClinicsController definition

        @clinics = Clinic.order(:name) # grab all Clinics from the database and order them by name

        # no explicity redirect so this action will render the index template: app/views/clinics/index.html.erb

    end # end of the #index action in the ClinicsController definition


    def search # start of the #search action in the ClinicsController definition
        
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
            flash[:error] = "Please provide at least a specialty or location to search"
            @clinics = Clinic.none
            return
        end

        # use the model's search method
        @clinics = Clinic.search_clinic(specialty, location)

    end # end of the #search action in the ClinicsController definition


    private

    def require_login # start of the require_login method definition

        unless session[:user_id]
            redirect_to login_path # redirect to the login page if the user is not logged in
        end

    end # end of the require_login method definition


end


