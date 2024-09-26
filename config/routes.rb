Rails.application.routes.draw do

    devise_for :users
    
    root to: "homes#top"
    get 'homes/about', to: 'homes#about', as: :about
    resources :posts, only: [:new, :create, :index, :show, :edit, :destroy]do
        patch :toggle_status
        resource :favorite, only: [:create, :destroy]
        resources :post_comments, only: [:create, :destroy]
    end
    resources :users, only: [:show, :edit, :update]

end