Gig::Application.routes.draw do
  root :to => "users#index"

  get "/login" => redirect("/auth/github"), :as => :login

  controller :sessions do
    get "auth/:provider/callback" => :callback
    get "auth/failure"            => :failure
    delete "logout"               => :destroy, :as => :logout
  end

  resource :cache, :only => :create

  resources :users, :only => [:index, :show], :path => "" do
    resources :entries, :except => :index, :path => "", :constraints => { :id => /.+/ }
  end
end
