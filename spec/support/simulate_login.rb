module SimulateLogin
    def login_patient(controller_spec = false)
        pat = FactoryBot.create(:patient)
        if controller_spec
            session[:user_id] = pat.id
            session[:role] = 'patient'
        else
            post login_path, params: {email: pat.email, password: "secret12", role: "patient"}
        end
        return pat
    end
    
    def login_doctor(controller_spec = false)
        doc = FactoryBot.create(:doctor)
        if controller_spec
            session[:user_id] = doc.id
            session[:role] = 'doctor'
        else
            post login_path, params: {email: doc.email, password: "secret12", role: "doctor"}
        end
        return doc
    end

    def login_admin(controller_spec = false)
        adm = FactoryBot.create(:admin)
        if controller_spec
            session[:user_id] = adm.id
            session[:role] = 'admin'
        else
            post login_path, params: {email: adm.email, password: "secret12", role: "admin"}
        end
        return adm
    end
end

RSpec.configure do |config|
    config.include SimulateLogin
end