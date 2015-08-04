Rails.application.routes.draw do

  mount ProductionOrderx::Engine => "/production_orderx"
  mount Authentify::Engine => "/authentify"
  mount Commonx::Engine => "/commonx"
  mount Searchx::Engine => '/search'
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end
