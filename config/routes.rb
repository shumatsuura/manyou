Rails.application.routes.draw do
  root 'tasks#home'
  resources :tasks
  resources :users, only:[:new,:show,:create]
  resources :sessions, only:[:new, :create, :destroy]

  namespace :admin do
    resources :users
  end

  resources :groups
  resources :group_relations, only: [:create, :destroy]

  resources :labels, only:[:new,:create,:edit,:update,:destroy]

end
