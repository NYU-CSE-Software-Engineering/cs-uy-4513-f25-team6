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

  # Dashboard routes
  get '/patient/dashboard', to: 'patient#dashboard', as: :patient_dashboard
  get '/doctor/dashboard', to: 'doctor#dashboard', as: :doctor_dashboard
  get '/admin/dashboard', to: 'admin#dashboard', as: :admin_dashboard

  root 'login#form'




  # TODO: make this a standardized resource route
  get '/clinic/:cl_id/doctors', to: 'clinic#doctors'

  # TODO: make this a standardized resource route
  get  '/doctor/:id/schedule_appt', to: 'doctor#schedule', as: :doctor_schedule

  # create appointment
  resources :appointments, only: [:create]

  # TODO: make this a standardized resource route
  get '/patient/appointments', to: 'appointments#index', as: :patient_appointments
end