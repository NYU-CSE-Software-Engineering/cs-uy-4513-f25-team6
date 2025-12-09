Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root to: redirect('/login')

  # Login routes
  get '/login', to: 'login#form', as: :login
  post '/login', to: 'login#login'
  get '/logout', to: 'login#logout', as: :logout

  # Non-RESTful patient routes
  get '/patient/dashboard', to: 'dashboard#patient', as: :patient_dashboard
  get '/patient/appointments', to: 'appointments#index', as: :patient_appointments

  # Non-RESTful doctor routes
  get '/doctor/dashboard', to: 'dashboard#doctor', as: :doctor_dashboard
  get '/doctor/time_slots', to: 'time_slots#configure', as: :configure_time_slots

  # Non-RESTful admin routes
  get '/admin/dashboard', to: 'dashboard#admin', as: :admin_dashboard

  # /clinics/:clinic_id/doctors
  resources :clinics do
    collection do
      # collection routes are routes that are not associated with a specific clinic --- routes operate on the entire collection of clinics resource
      get 'search' # maps `GET /clinics/search` to ClinicsController#search action
                    # creating a custom route (not one of the default RESTful routes)
    end

    resources :doctors, only: [:index] do
      collection do
        get 'search'  # maps GET /clinics/:clinic_id/doctors/search to DoctorsController#search
      end
    end
    
  end

  resources :patients, only: [:new, :create]

  resources :doctors, only: [:new, :create, :update] do
    resources :time_slots, only: [:index, :create, :destroy]
  end

  resources :admins, only: [:new, :create]
  
  resources :appointments, only: [:create]

  resources :bills, only: [:show, :update], path: "billing", as: "billing"
end