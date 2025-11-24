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
  delete '/logout', to: 'login#logout', as: :logout

  # Non-RESTful patient routes
  get '/patient/dashboard', to: 'dashboard#patient', as: :patient_dashboard
  get '/patient/appointments', to: 'appointments#index', as: :patient_appointments

  # Non-RESTful doctor routes
  get '/doctor/dashboard', to: 'dashboard#doctor', as: :doctor_dashboard

  # Non-RESTful admin routes
  get '/admin/dashboard', to: 'dashboard#admin', as: :admin_dashboard

  # /clinics/:clinic_id/doctors
  resources :clinics do
    resources :doctors, only: [:index]
  end

  # /doctors/:doctor_id/time_slots
  resources :doctors, only: [] do
    resources :time_slots, only: [:index]
  end
  
  resources :appointments, only: [:create]

  resources :bills, only: [:show, :update], path: "billing", as: "billing"
end