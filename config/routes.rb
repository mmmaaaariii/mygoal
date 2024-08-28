Rails.application.routes.draw do

    devise_for :users
    
    root to: "homes#top"
    get 'homes/about', to: 'homes#about', as: :about
    resources :posts, only: [:new, :create, :index, :show, :destroy]do
        patch :toggle_status
    end
    resources :users, only: [:show, :edit, :update]

end