Rails.application.routes.draw do
  devise_for :users

  root :to =>"homes#top"
  get "about"=>"homes#about"

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:index,:show,:edit,:update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  get "search" => "searches#search"
  get "users/search", to: "users#search", as: "user_search"

  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end