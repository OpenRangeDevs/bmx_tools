Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Club-specific routes (bmxtools.com/[club-name])
  constraints(club_slug: /[a-z0-9\-]+/) do
    get "/:club_slug", to: "races#show", as: :club
    get "/:club_slug/race", to: "races#show", as: :club_race
    get "/:club_slug/admin", to: "races#admin", as: :club_admin
    patch "/:club_slug/race", to: "races#update", as: :club_race_update
    patch "/:club_slug/race/settings", to: "races#update_settings", as: :club_race_settings
    post "/:club_slug/race/new", to: "races#create_new_race", as: :club_new_race

    # Admin authentication routes
    get "/:club_slug/admin/login", to: "admin/sessions#new", as: :club_admin_login
    post "/:club_slug/admin/login", to: "admin/sessions#create"
    delete "/:club_slug/admin/logout", to: "admin/sessions#destroy", as: :club_admin_logout
  end

  # Defines the root path route ("/")
  root "home#index"
end
