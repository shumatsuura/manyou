Rails.application.routes.draw do
  get 'users/new'
  get 'users/show'
  root 'tasks#index'
  resources :tasks
end
