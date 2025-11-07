

class DoctorController < ApplicationController
    def dashboard
        @user = Doctor.find(session[:user_id])
    end
end