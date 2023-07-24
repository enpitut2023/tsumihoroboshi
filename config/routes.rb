Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  
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

  resources :likes, only: %i[index create destroy]

  post "/users/:user_id/timers/start", to: 'timers#start'
  patch "/users/:user_id/timers/:id/stop", to: "timers#stop"
  delete "/users/:user_id/timers/:id", to: "timers#destroy"

end
