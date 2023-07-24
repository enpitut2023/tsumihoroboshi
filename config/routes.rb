Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/destroy'
  get '/likes', to: 'likes#index'
  get 'relationships/followings'
  get 'relationships/followers'
  root to: 'homes#top'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :books do
    resources :tsundokus
  end
  resources :users do
    resources :searches
  end

  resources :users do
    resource :relationships, only: %i[create destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :users do
    member do
      get :followings, :followers
    end
  end

  resources :likes, only: %i[create destroy]
end
