

class PatientController < ApplicationController
    def dashboard
        @user = Patient.find(session[:user_id])
    end
end