Rails.application.routes.draw do
  resources :dashboard, only: :index
  root 'employees#index'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  resources :employees do
    collection do
      post :export
      match :upload, via: %i[get post]
    end
    resources :profiles
    resources :articles, only: %i[new create update edit]
  end

  resources :articles, only: %i[index show destroy]
end
