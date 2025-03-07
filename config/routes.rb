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
  root "select_report_day#select_day"

  get "select_day", to: "select_report_day#select_day"
  get "select_previous_or_next_day", to: "select_report_day#select_previous_or_next_day"
  get "correct_data_for_month_report", to: "monthly_reports#correct_data_for_month_report"
  get "correct_month_report_data_form", to: "monthly_reports#correct_month_report_data_form"

  post "add_info_to_children", to: "select_report_day#add_info_to_children"
  post "add_info_about_visit", to: "select_report_day#add_info_about_visit"
  post "add_info_about_skip", to: "select_report_day#add_info_about_skip"

  patch "refresh_info_about_visit", to: "select_report_day#refresh_info_about_visit"
  patch "overwrite_children_info", to: "monthly_reports#overwrite_children_info"
  patch "overwrite_child_info", to: "monthly_reports#overwrite_child_info"

  resources :monthly_reports, only: %i[create]
end
