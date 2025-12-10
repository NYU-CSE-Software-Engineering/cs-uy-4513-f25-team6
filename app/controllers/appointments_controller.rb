class AppointmentsController < ApplicationController
  before_action { check_login ['patient', 'doctor'] }

  def index
    unless session[:user_id]
      flash[:alert] = "You are not authorized to view this page."
      redirect_to login_path
      return
    end

    if session[:role] == 'doctor'
      # Logic for Doctor
      @appointments = Appointment.includes(:time_slot, :patient, :doctor, :bill)
                                 .where(time_slots: {doctor_id: session[:user_id]})
    elsif session[:role] == 'patient'
      # Logic for Patient
      @appointments = Appointment.joins(:time_slot).includes(:time_slot, :doctor)
                                 .where(patient_id: session[:user_id])
    end

    if params[:status].present? && params[:status] != "All"
      if params[:status] == 'Upcoming'
        @appointments = @appointments.where('date > ? OR (DATE = ? AND time_slots.starts_at > ?)', Date.today, Date.today, DateTime.now.strftime('%H:%M:%S'))
      elsif params[:status] == 'Completed'
        @appointments = @appointments.where('date < ? OR (DATE = ? AND time_slots.starts_at <= ?)', Date.today, Date.today, DateTime.now.strftime('%H:%M:%S'))
      end
    end
  end

  def create
    slot = TimeSlot.find(params.dig(:appointment, :time_slot_id))
    date = params.dig(:appointment, :date)

    if Appointment.exists?(time_slot: slot, date: date)
      redirect_to doctor_time_slots_path(slot.doctor.id), alert: "Time slot no longer available"
      return
    end

    Appointment.create!(patient_id: session[:user_id], time_slot: slot, date: date)
    redirect_to patient_appointments_path, notice: "Appointment confirmed"
  end

end