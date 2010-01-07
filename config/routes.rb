ActionController::Routing::Routes.draw do |map|

  map.resources :friendships, :badges
  # map.resources :search, :only => :index
  map.resources :statements, :member => { :vote => :post }
  map.resources :whois, :member => { :change_whois => :post, :describe_friend => :get, :get_close_friend => :get  }
  map.resources :users, :only => [:update_settings, :show, :check_user], :member => { :update_settings => :post}
  map.resource :user_session, :users
  map.home "/home", :controller => "home", :action => "home"
  map.welcome "/welcome", :controller => "home", :action => "welcome"
  map.login "/login", :controller => "user_sessions", :action => "new"
  map.logout "/logout", :controller => "user_sessions", :action => "destroy"
  map.tag "/tag/:tag", :controller => "tags", :action => "index"
  map.search_everyone "/search/everyone/:search", :controller => "search", :action => "everyone"
  map.search "/search/:search", :controller => "search", :action => "index"
  map.check_user "/users/check/:fbuid", :controller => "users", :action => "check_user"
  map.user_page "/:title", :controller => "users", :action => "show"
  map.root :controller => "home", :action => "root" # optional, this just sets the root route
    
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
