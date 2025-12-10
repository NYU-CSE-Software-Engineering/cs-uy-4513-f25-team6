class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :get_user

  rescue_from ActiveRecord::RecordNotFound, with: :back_to_homepage

  private

  def get_user()
    case session[:role]
    when 'patient' then @user = Patient.find(session[:user_id])
    when 'doctor' then @user = Doctor.find(session[:user_id])
    when 'admin' then @user = Admin.find(session[:user_id])
    end
  end

  def check_login(roles = ['any'])
    if !session[:user_id] || (roles != ['any'] && !roles.include?(session[:role]))
      redirect_to login_path, alert: "This page or action requires you to be logged in as: #{roles}"
    end
  end

  def back_to_homepage(exception)
    flash[:alert] = "There is no #{exception.model.downcase} with id #{exception.id}"
    case session[:role]
    when 'patient' then redirect_to patient_dashboard_path
    when 'doctor' then redirect_to doctor_dashboard_path
    when 'admin' then redirect_to admin_dashboard_path
    else redirect_to clinics_path
    end
  end
end
