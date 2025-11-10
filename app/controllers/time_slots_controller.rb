class TimeSlotsController < ApplicationController
    def index
        @doctor = Doctor.find(params[:doctor_id])
        @date = params[:schedule_date] || Date.today

        taken_slots = TimeSlot.joins(:appointments).where(doctor: @doctor, appointments: {date: @date})
        @time_slots = TimeSlot.where(doctor: @doctor)
                              .excluding(taken_slots)
                              .order(:starts_at)
    end
end