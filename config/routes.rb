Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :tickets, only: [:index, :show, :create, :update] do
        member do
          post :link_known_issues
        end
      end

      resources :known_issues, only: [:index, :show, :create, :update]
      resources :glossary_terms, only: [:index, :show, :create, :update]
    end
  end

  get "/health", to: proc { [200, {}, ['{"status":"ok"}']] }
end
