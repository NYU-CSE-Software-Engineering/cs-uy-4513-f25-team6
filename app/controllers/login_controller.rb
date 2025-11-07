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
        email = params[:email]
        password = params[:password]
        role = params[:role]

        if email.blank? || password.blank?
            flash[:danger] = 'Invalid email or password'
            render :new
            return
        elsif role.blank?
            flash[:danger] = 'You must select a role'
            render :new
            return
        end

        user = find_user_by_email(email, role)
        
        if user && authenticate_user(user, password)
            session[:user_id] = user.id
            session[:role] = role
            redirect_to dashboard_path_for_user(user)
        else
            flash[:danger] = 'Invalid email or password'
            render :new
        end
    end

    def destroy
        session[:user_id] = nil
        flash[:info] = 'Logged out successfully'
        redirect_to root_path
    end

    private

    def current_user
        return nil unless session[:user_id]
        
        @current_user ||= find_user_by_id(session[:user_id], session[:role])
    end

    def find_user_by_email(email, role)
        case role
        when 'patient'
            return Patient.find_by(email: email)
        when 'doctor'
            return Doctor.find_by(email: email)
        when 'admin'
            return Admin.find_by(email: email)
        end
    end

    def find_user_by_id(id, role)
        case role
        when 'patient'
            return Patient.find_by(id: id)
        when 'doctor'
            return Doctor.find_by(id: id)
        when 'admin'
            return Admin.find_by(id: id)
        end
    end

    def authenticate_user(user, password)
        password_hash = Digest::MD5.hexdigest(password)
        user.password == password_hash
    end

    def dashboard_path_for_user(user)
        case user.class.name
        when 'Patient'
            return patient_dashboard_path
        when 'Doctor'
            return doctor_dashboard_path
        when 'Admin'
            return admin_dashboard_path
        else
            return root_path
        end
    end
end