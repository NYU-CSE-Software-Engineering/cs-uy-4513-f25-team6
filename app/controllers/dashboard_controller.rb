class DashboardController < ApplicationController
    def patient
        @user = Patient.find(session[:user_id])
    end
    
    def doctor
        @user = Doctor.find(session[:user_id])
    end

    def admin
        @user = Admin.find(session[:user_id])
    end
end