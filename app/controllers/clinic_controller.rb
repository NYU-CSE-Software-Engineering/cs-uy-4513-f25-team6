class ClinicController < ApplicationController
    def doctors
        @id = params[:cl_id]
        @doctors = Clinic.find(params[:cl_id]).doctors
    end
end