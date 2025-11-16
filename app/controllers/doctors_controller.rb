# this is for RESTful doctor pages

class DoctorsController < ApplicationController
    def index
        @id = params[:cl_id]
        @doctors = Clinic.find(params[:clinic_id]).doctors
    end
end