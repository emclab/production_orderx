ProductionOrderx::Engine.routes.draw do
  
  resources :production_steps
  resources :part_productions do
    collection do
      get :search
      get :search_results
      get :stats
      get :stats_results
    end
  end
  
  root :to => 'part_productions#index'

end
