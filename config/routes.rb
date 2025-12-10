Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root to: redirect('/clinics')

  # =========== NON RESTFUL ROUTES ===========

  # Login
  get '/login', to: 'login#form', as: :login
  post '/login', to: 'login#login'
  get '/logout', to: 'login#logout', as: :logout

  # Patient
  get '/patient/dashboard', to: 'dashboard#patient', as: :patient_dashboard
  get '/patient/appointments', to: 'appointments#index', as: :patient_appointments
  get '/patient/prescriptions', to: 'prescriptions#patient_index', as: :patient_prescriptions

  # Doctor
  get '/doctor/dashboard', to: 'dashboard#doctor', as: :doctor_dashboard
  get '/doctor/time_slots', to: 'time_slots#configure', as: :configure_time_slots
  get '/doctor/appointments', to: 'appointments#index', as: :doctor_appointments
  get '/doctor/prescriptions', to: 'prescriptions#doctor_index', as: :doctor_prescriptions

  # Admin
  get '/admin/dashboard', to: 'dashboard#admin', as: :admin_dashboard

  # ============= RESTFUL ROUTES =============
  
  resources :clinics, only: [:index, :create] do
    resources :doctors, only: [:index]
  end

  resources :patients, only: [:new, :create]

  resources :doctors, only: [:new, :create, :update] do
    resources :time_slots, only: [:index, :create, :destroy]
  end

  resources :admins, only: [:new, :create]
  
  resources :appointments, only: [:create] do
    resources :bills, only: [:new, :create]
  end

  resources :prescriptions, only: [:create, :update]

  resources :bills, only: [:show, :update]
end