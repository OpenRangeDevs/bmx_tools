Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Club-specific routes (bmxtools.com/[club-name])
  constraints(club_slug: /[a-z0-9\-]+/) do
    get "/:club_slug", to: "races#show", as: :club_race
    get "/:club_slug/admin", to: "races#admin", as: :club_admin
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
