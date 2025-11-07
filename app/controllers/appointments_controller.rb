class AppointmentsController < ApplicationController

  def create
    slot   = TimeSlot.find(params.dig(:appointment, :time_slot_id))
    doctor = Doctor.find(params.dig(:appointment, :doctor_id))

    if Appointment.exists?(time_slot_id: slot.id)
      redirect_to doctor_schedule_path(id: doctor.user.username), alert: "Time slot no longer available"
      return
    end

    Appointment.create!(patient: nil, doctor: doctor, time_slot: slot)
    redirect_to patient_appointments_path, notice: "Appointment confirmed"
  end

  def index
    render inline: "<h1>My Appointments</h1><p><%= flash[:notice] %></p>"
  end
end
