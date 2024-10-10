Rails.application.routes.draw do
  
  devise_for :admin, skip: [:registrations, :password], controllers: {
    sessions: 'admin/sessions'
  }
 
  namespace :admin do
    get 'dashboards', to: 'dashboards#index'
    resources :users, only: [:index, :destroy]
    resources :post_comments, only: [:index, :destroy]
  end
  
  get 'relationships/followings'
  get 'relationships/followers'
  
  scope module: :public do
    devise_for :users
    root to: "homes#top"
    get 'homes/about', to: 'homes#about', as: :about
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy]do
        patch :toggle_status
        resource :favorite, only: [:create, :destroy]
        resources :post_comments, only: [:create, :destroy]
        get 'search_results', on: :collection
    end
    resources :users, only: [:show, :edit, :update, :destroy]do
        resource :relationships, only: [:create, :destroy]
        get 'followings' => 'relationships#followings', as: 'followings'
        get 'followers' => 'relationships#followers', as: 'followers'
    end
    
    resources :groups, only: [:new, :index, :show, :create, :edit, :update]
    
  end

end