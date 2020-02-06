Rails.application.routes.draw do
  root 'tasks#home'
  resources :tasks
  resources :users, only:[:new,:show,:create]
  resources :sessions, only:[:new, :create, :destroy]
  namespace :admin do
    resources :users
  end

  resources :labels

end
