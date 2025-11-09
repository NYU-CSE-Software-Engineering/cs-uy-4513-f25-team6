Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Login routes
  get '/login', to: 'login#form', as: :login
  post '/login', to: 'login#login'
  delete '/logout', to: 'login#logout', as: :logout

  # Non-RESTful routes that use the session id
  get '/patient/dashboard', to: 'patient#dashboard', as: :patient_dashboard
  get '/patient/appointments', to: 'appointments#index', as: :patient_appointments

  get '/doctor/dashboard', to: 'doctor#dashboard', as: :doctor_dashboard

  get '/admin/dashboard', to: 'admin#dashboard', as: :admin_dashboard

  root 'login#form'

  # TODO: use nested resource generators for these
  get '/clinic/:cl_id/doctors', to: 'clinic#doctors'
  get '/doctor/:id/time_slots', to: 'doctor#schedule', as: :doctor_time_slots
  
  # create appointment
  resources :appointments, only: [:create]
end