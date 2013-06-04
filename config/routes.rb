Nub::Application.routes.draw do
  authenticated :person do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :people
  resources :people
end