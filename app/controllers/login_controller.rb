require 'digest'

class LoginController < ApplicationController
    def form
        if session[:user_id] && session[:role]
            redirect_to dashboard_path_for(session[:role])
        else
            render :form
        end
    end

    def login
        email = params[:email]
        password = params[:password]
        role = params[:role]

        if email.blank? || password.blank?
            flash[:alert] = 'Invalid email or password'
            render :form
            return
        elsif role.blank?
            flash[:alert] = 'You must select a role'
            render :form
            return
        end

        user = find_user_by({
            email: email, 
            password: Digest::MD5.hexdigest(password)
        }, role)
        
        if user
            session[:user_id] = user.id
            session[:role] = role
            redirect_to dashboard_path_for(role)
        else
            flash[:alert] = 'Invalid email or password'
            render :form
        end
    end

    def logout
        session[:user_id] = nil
        session[:role] = nil
        redirect_to login_path, notice: 'Successfully logged out'
    end

    private

    def find_user_by(hash, role)
        case role.downcase
        when 'patient'
            return Patient.find_by(hash)
        when 'doctor'
            return Doctor.find_by(hash)
        when 'admin'
            return Admin.find_by(hash)
        end
    end

    def dashboard_path_for(role)
        case role.downcase
        when 'patient'
            return patient_dashboard_path
        when 'doctor'
            return doctor_dashboard_path
        when 'admin'
            return admin_dashboard_path
        else
            return root_path
        end
    end
end