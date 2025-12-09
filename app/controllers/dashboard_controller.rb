class DashboardController < ApplicationController
  def patient

    @appointments = Appointment
                      .joins(:time_slot)
                      .includes(:time_slot, :doctor)
                      .where(patient_id: @user.id)
                      .order(:date, 'time_slots.starts_at')

    @unpaid_bills = Bill
                      .joins(:appointment)
                      .where(appointments: { patient_id: @user.id }, status: "unpaid")
  end

  def doctor

    @appointments = Appointment
                      .joins(:time_slot)
                      .includes(:patient, :time_slot)
                      .where(time_slots: { doctor_id: @user.id })
                      .order(:date, 'time_slots.starts_at')
  end

  def admin
    @patients_count     = Patient.count
    @doctors_count      = Doctor.count
    @appointments_count = Appointment.count
    @unpaid_bills_count = Bill.where(status: "unpaid").count
  end
end