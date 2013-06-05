Nub::Application.routes.draw do
  match '/people/login' => redirect { '/people/auth/twitter'}
  authenticated :person do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :people, path_names: {sign_in: "login", sign_out: "logout"}, controllers: {omniauth_callbacks: "omniauth_callbacks"}
  resources :people
end