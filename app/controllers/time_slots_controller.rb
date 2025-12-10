class TimeSlotsController < ApplicationController
    before_action(only: [:index]) { check_login }
    before_action(only: [:configure, :create, :destroy]) { check_login ['doctor'] }
    
    def index
        @doctor = Doctor.find(params[:doctor_id])
        @date = params[:schedule_date] || Date.today
        taken_slots = TimeSlot.joins(:appointments).where(doctor: @doctor, appointments: {date: @date})
        @time_slots = TimeSlot.where(doctor: @doctor)
                            .excluding(taken_slots)
                            .order(:starts_at)
    end

    def configure
        @time_slots = Doctor.find(session[:user_id]).time_slots
    end

    def create
        if (session[:role] == 'doctor' && params[:doctor_id] != session[:user_id].to_s)
            redirect_to configure_time_slots_path, alert: "Attempted to add a time slot to another doctor (this should not be possible)"
            return
        end
        
        new_slot = TimeSlot.new({doctor_id: params[:doctor_id], starts_at: params[:starts_at], ends_at: params[:ends_at]})
        
        if (new_slot.valid?)
            new_slot.save
            redirect_to configure_time_slots_path, notice: 'Succesfully added new time slot'
        else
            redirect_to configure_time_slots_path, alert: "Invalid time slot details: #{new_slot.errors.as_json}"
        end
    end

    def destroy
        to_delete = TimeSlot.find_by(id: params[:id])
        if (to_delete == nil)
            redirect_to configure_time_slots_path, alert: 'Attempted to remove a nonexistent slot (this should not be possible)'
            return
        elsif (session[:role] == 'doctor' && to_delete.doctor.id != session[:user_id])
            redirect_to configure_time_slots_path, alert: 'Attempted to remove a slot from another doctor (this should not be possible)'
            return
        end

        to_delete.destroy
        redirect_to configure_time_slots_path, notice: 'Successfully removed time slot'
    end
end