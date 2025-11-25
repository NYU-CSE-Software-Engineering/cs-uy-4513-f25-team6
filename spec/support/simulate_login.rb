module SimulateLogin
    def login_patient
        pat = FactoryBot.create(:patient)
        post login_path, params: {email: pat.email, password: "secret12", role: "patient"}
        return pat
    end
    
    def login_doctor
        doc = FactoryBot.create(:doctor)
        post login_path, params: {email: doc.email, password: "secret12", role: "doctor"}
        return doc
    end

    def login_admin
        adm = FactoryBot.create(:admin)
        post login_path, params: {email: adm.email, password: "secret12", role: "admin"}
        return adm
    end
end

RSpec.configure do |config|
    config.include SimulateLogin
end