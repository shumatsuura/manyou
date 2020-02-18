Rails.application.routes.draw do
  root 'tasks#home'
  resources :tasks do
    collection do
      get :calendar
    end
  end

  resources :users, only:[:new, :show, :create, :edit,:update]
  resources :sessions, only:[:new, :create, :destroy]

  namespace :admin do
    resources :users
  end

  resources :groups do
    resources :group_tasks
  end

  resources :group_relations, only: [:create, :destroy]

  resources :labels, only:[:new,:create,:edit,:update,:destroy]

end
