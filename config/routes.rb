Rails.application.routes.draw do
  
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }
 
  namespace :admin do
    get 'dashboards', to: 'dashboards#index'
    resources :users, only: [:index, :show, :destroy]
    resources :post_comments, only: [:index, :destroy]
  end
  
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  
  scope module: :public do
    devise_for :users
    root to: "homes#top"
    get "homes/about", to: "homes#about", as: "about"
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy]do
      patch :toggle_status
      resource :favorite, only: [:create, :destroy]
      resources :post_comments, only: [:create, :destroy]
    end
    resources :users, only: [:index, :show, :edit, :update, :destroy]do
      resource :relationships, only: [:create, :destroy]
      get 'relationships/followings'
      get 'relationships/followers'
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end
    
    resources :groups do
      resource :group_users, only: [:create, :destroy]
      member do
        get 'new_group_message', to: 'groups#new_group_message', as: "new_message"
        post 'group_messages', to: 'groups#create_group_message', as: "messages"
      end
    end
    
    get 'search', to: 'searches#search', as: 'search'
    
    if Rails.env.development?
      mount LetterOpenerWeb::Engine, at: "/letter_opener"
    end
    
  end
  
  


end