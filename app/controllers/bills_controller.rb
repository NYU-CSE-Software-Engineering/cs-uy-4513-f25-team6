class BillsController < ApplicationController
  before_action { check_login }
  before_action(only: [:new, :create]) { check_login ['doctor'] }
  before_action :set_bill, only: [:show, :update]

  def new
    @app = Appointment.find(params[:appointment_id])
  end

  def create
    @app = Appointment.find(params[:appointment_id])
    bill_params = params.expect(bill: [:amount, :due_date])
    
    bill = Bill.new(bill_params)
    bill.appointment_id = @app.id

    if bill.valid?
      bill.save
      flash[:notice] = 'New bill successfully created'
      redirect_to doctor_appointments_path
    else
      flash[:alert] = 'Invalid bill details'
      render :new
    end
  end

  def show
  end

  def update
    if session[:role] == 'doctor'
      redirect_to doctor_dashboard_path, alert: "You are not authorized to pay this bill"
      return
    elsif session[:role] == 'admin'
      redirect_to admin_dashboard_path, alert: "You are not authorized to pay this bill"
      return
    end

    if @bill.paid?
      flash[:alert] = "This bill is already paid"
      redirect_to bill_path(@bill)
      return
    end

    if valid_payment_params?
      @bill.mark_as_paid!
      flash[:notice] = "Payment successful"
      redirect_to bill_path(@bill)
    else
      flash.now[:alert] = "Please enter a valid card number"
      render :show, status: :unprocessable_content
    end
  end

  private

  def set_bill
    @bill = Bill.find(params[:id])
    if session[:role] == 'patient' && @bill.patient.id != session[:user_id]
      redirect_to patient_dashboard_path, alert: "You are not authorized to access this bill"
    elsif session[:role] == 'doctor' && @bill.doctor.id != session[:user_id]
      redirect_to doctor_dashboard_path, alert: "You are not authorized to access this bill"
    end
  end

  def valid_payment_params?
    card_number = params[:card_number]&.strip
    return false if card_number.blank?

    # Basic validation: card number should be 13-19 digits
    card_number.match?(/^\d{13,19}$/)
  end
end
