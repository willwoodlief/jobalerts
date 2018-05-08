Rails.application.routes.draw do

  get 'jobs/list'
  get 'jobs/update'
  # Home controller routes.
  root   'home#index'
  get    'auth'            => 'home#auth'

  # Get login token from Knock
  post   'user_token'      => 'user_token#create'

  # User actions
  get    '/users'          => 'users#index'
  get    '/users/current'  => 'users#current'
  # post   '/users/create'   => 'users#create'
  patch  '/user/:id'       => 'users#update'
  delete '/user/:id'       => 'users#destroy'

  #job actions
  get  '/jobs/list'  => 'jobs#list'
  post '/jobs/update' => 'jobs#update'
  post '/jobs/run' => 'jobs#run'
  get '/jobs/stats' => 'jobs#stats'

end