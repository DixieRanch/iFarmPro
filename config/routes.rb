# == Route Map
#
#                  Prefix Verb   URI Pattern                             Controller#Action
#                sessions POST   /sessions(.:format)                     sessions#create
#             new_session GET    /sessions/new(.:format)                 sessions#new
#                 session DELETE /sessions/:id(.:format)                 sessions#destroy
#               companies POST   /companies(.:format)                    companies#create
#                 company GET    /companies/:id(.:format)                companies#show
#                   users POST   /users(.:format)                        users#create
#                   farms GET    /farms(.:format)                        farms#index
#                         POST   /farms(.:format)                        farms#create
#                new_farm GET    /farms/new(.:format)                    farms#new
#               edit_farm GET    /farms/:id/edit(.:format)               farms#edit
#                    farm GET    /farms/:id(.:format)                    farms#show
#                         PATCH  /farms/:id(.:format)                    farms#update
#                         PUT    /farms/:id(.:format)                    farms#update
#             irrigations GET    /irrigations(.:format)                  irrigations#index
#                         POST   /irrigations(.:format)                  irrigations#create
#         edit_irrigation GET    /irrigations/:id/edit(.:format)         irrigations#edit
#              irrigation PATCH  /irrigations/:id(.:format)              irrigations#update
#                         PUT    /irrigations/:id(.:format)              irrigations#update
#                  report GET    /reports/:id(.:format)                  reports#show
#                   rains GET    /rains(.:format)                        rains#index
#                         POST   /rains(.:format)                        rains#create
#               edit_rain GET    /rains/:id/edit(.:format)               rains#edit
#                    rain PATCH  /rains/:id(.:format)                    rains#update
#                         PUT    /rains/:id(.:format)                    rains#update
#           soil_products GET    /soil_products(.:format)                soil_products#index
#                         POST   /soil_products(.:format)                soil_products#create
#       edit_soil_product GET    /soil_products/:id/edit(.:format)       soil_products#edit
#            soil_product PATCH  /soil_products/:id(.:format)            soil_products#update
#                         PUT    /soil_products/:id(.:format)            soil_products#update
#       soil_applications GET    /soil_applications(.:format)            soil_applications#index
#                         POST   /soil_applications(.:format)            soil_applications#create
#   edit_soil_application GET    /soil_applications/:id/edit(.:format)   soil_applications#edit
#        soil_application PATCH  /soil_applications/:id(.:format)        soil_applications#update
#                         PUT    /soil_applications/:id(.:format)        soil_applications#update
#     account_activations POST   /account_activations(.:format)          account_activations#create
#  new_account_activation GET    /account_activations/new(.:format)      account_activations#new
# edit_account_activation GET    /account_activations/:id/edit(.:format) account_activations#edit {:id=>/[^\/]+/}
#      account_activation GET    /account_activations/:id(.:format)      account_activations#show {:id=>/[^\/]+/}
#         password_resets POST   /password_resets(.:format)              password_resets#create
#      new_password_reset GET    /password_resets/new(.:format)          password_resets#new
#     edit_password_reset GET    /password_resets/:id/edit(.:format)     password_resets#edit {:id=>/[^\/]+/}
#          password_reset GET    /password_resets/:id(.:format)          password_resets#show {:id=>/[^\/]+/}
#                         PATCH  /password_resets/:id(.:format)          password_resets#update {:id=>/[^\/]+/}
#                         PUT    /password_resets/:id(.:format)          password_resets#update {:id=>/[^\/]+/}
#        user_invitations POST   /user_invitations(.:format)             user_invitations#create
#     new_user_invitation GET    /user_invitations/new(.:format)         user_invitations#new
#    edit_user_invitation GET    /user_invitations/:id/edit(.:format)    user_invitations#edit {:id=>/[^\/]+/}
#         user_invitation PATCH  /user_invitations/:id(.:format)         user_invitations#update {:id=>/[^\/]+/}
#                         PUT    /user_invitations/:id(.:format)         user_invitations#update {:id=>/[^\/]+/}
#                    root GET    /                                       static_pages#home
#                  signup GET    /signup(.:format)                       companies#new
#                  signin GET    /signin(.:format)                       sessions#new
#                 signout DELETE /signout(.:format)                      sessions#destroy
#                    help GET    /help(.:format)                         static_pages#help
#                 contact GET    /contact(.:format)                      static_pages#contact
#                   about GET    /about(.:format)                        static_pages#about
#

Ifarm::Application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  resources :companies, only: [:create, :show]
  resources :users, only: [:create]
  resources :farms, only: [:index, :show, :new, :create, :edit, :update]
  resources :irrigations, only: [:index, :create, :edit, :update]
  resources :reports, only: [:show]
  resources :rains, only: [:index, :edit, :create, :update]
  resources :soil_products, only: [:index, :create, :edit, :update]
  resources :soil_applications, only: [:index, :create, :edit, :update]
  resources :account_activations, only: [:show, :new, :create, :edit],
                                  constraints: { id: /[^\/]+/ }
  resources :password_resets, only: [:show, :new, :create, :edit, :update],
                              constraints: { id: /[^\/]+/ }
  resources :email_changes, only: [:index, :new, :show, :create, :edit],
                              constraints: { id: /[^\/]+/ }
  resources :user_invitations, only: [:new, :create, :edit, :update],
                              constraints: { id: /[^\/]+/ }
  resources :freezer_locations, only: [:index, :create, :edit, :update],
                              constraints: { id: /[^\/]+/ }
  resources :boxes, only: [:index, :create, :edit, :update],
                    constraints: { id: /[^\/]+/ }
  resources :lots, only: [:new, :create, :edit, :update]
  resources :loads, only: [:index, :edit, :update]
  resources :shipments, only: [:new, :create, :edit, :update]
  resources :shipment_selections, only: [:new]
  root to: 'static_pages#home'

  get '/signup',    to: 'companies#new'
  get '/signin',    to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete

  get '/help',      to: 'static_pages#help'
  get '/contact',   to: 'static_pages#contact'
  get '/about',     to: 'static_pages#about'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
