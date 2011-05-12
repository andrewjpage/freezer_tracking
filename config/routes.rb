FreezerTracking::Application.routes.draw do

  namespace :building_areas do
    resources :admins
  end
  resources :building_areas, :only => [:index, :show], :controller => 'building_areas/building_areas' do
    member do
      get :assets_spreadsheet
    end
  end
  
  namespace :freezers do
    resources :admins
  end
  resources :freezers, :only => [:index, :show], :controller => 'freezers/freezers' do
    member do
      get :assets_spreadsheet
    end
  end
  
  
  namespace :storage_areas do
    resources :admins
  end
  resources :storage_areas, :only => [:index, :show], :controller => 'storage_areas/storage_areas' do
    member do
      get :assets_spreadsheet
    end
  end
  
  
  namespace :assets do
    resources :admins
  end
  resources :assets, :only => [:index, :show], :controller => 'assets/assets' do
    member do
      get :assets_spreadsheet
    end
  end
  
  resources :receptions, :only => [:index, :create] 
  resources :asset_audits, :only => [:index]
  resources :searches, :only => [:index] do 
    collection do 
      post :search
    end
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"
  
  root :to => "receptions#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
