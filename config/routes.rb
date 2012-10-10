RailsSample::Application.routes.draw do
  resources :slides, :only => [:show]
  resources :action_items, :only => [:create, :update, :destroy]
  resources :users do
    member do
      put :change_password_update
    end
  end
  
  resources :story_boards
  resources :story_boards do
    resources :slides do
      post :resize
      post :crop
    end
    member do
      get :preview
      get :duplicate
    end
  end
  resources :story_board_attachments, :only => [:create]
  resources :sessions, :only => [:new, :create, :destroy]
  resources :user_prospects

  root :to => "home#index"
  
  match '/signup',  :to => 'users#new', :as => :sign_up
  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
  match '/change_password', :to => 'users#change_password', :as => :change_password

  match 'ajax/editable' => 'ajax#editable'
  

end
