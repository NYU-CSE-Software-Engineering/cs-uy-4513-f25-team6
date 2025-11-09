

class DoctorController < ApplicationController
    def dashboard
        @user = Doctor.find(session[:user_id])
    end

    def schedule
        @doctor = find_doctor!(params[:id])
        @date = params[:schedule_date] || Date.today

        taken_slots = TimeSlot.joins(:appointments).where(appointments: {date: @date})
        @time_slots = TimeSlot.where(doctor_id: @doctor.id)
                              .excluding(taken_slots)
                              .order(:starts_at)
    end
    
    private
    
    def find_doctor!(id_or_username)
        if id_or_username.to_s =~ /\A\d+\z/
            Doctor.find(id_or_username)
        else
            Doctor.find_by!(username: id_or_username )
        end
    end
end