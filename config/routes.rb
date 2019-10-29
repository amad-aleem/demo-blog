Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root 'pages#home'
  devise_for :users
  get 'home' => 'pages/home', as: :home
  resources :users do
    resources :likes
    resources :reports
    resources :posts do
      put 'publish' => 'posts#publish', on: :member
      put 'unpublish' => 'posts#unpublish', on: :member
      resources :comments, only: [:create]
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
