require 'digest'

class LoginController < ApplicationController
    def new
        if current_user
            redirect_to dashboard_path_for_user(current_user)
        else
            render :new
        end
    end

    def create
        email = params[:login]
        password = params[:password]

        if email.blank? || password.blank?
            flash[:alert] = 'Invalid email or password'
            render :new
            return
        end

        user = find_user_by_email(email)
        
        if user && authenticate_user(user, password)
            session[:user_id] = user.id
            redirect_to dashboard_path_for_user(user)
        else
            flash[:alert] = 'Invalid email or password'
            render :new
        end
    end

    def destroy
        session[:user_id] = nil
        flash[:notice] = 'Logged out successfully'
        redirect_to root_path
    end

    private

    def current_user
        return nil unless session[:user_id]
        
        @current_user ||= find_user_by_id(session[:user_id])
    end

    def find_user_by_email(email)
        Patient.find_by(email: email) ||
        Doctor.find_by(email: email) ||
        Admin.find_by(email: email)
    end

    def find_user_by_id(id)
        Patient.find_by(id: id) ||
        Doctor.find_by(id: id) ||
        Admin.find_by(id: id)
    end

    def authenticate_user(user, password)
        password_hash = Digest::MD5.hexdigest(password)
        user.password == password_hash
    end

    def dashboard_path_for_user(user)
        case user.class.name
        when 'Patient'
            patient_dashboard_path
        when 'Doctor'
            doctor_dashboard_path
        when 'Admin'
            admin_dashboard_path
        else
            root_path
        end
    end
end