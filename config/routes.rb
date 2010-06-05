ActionController::Routing::Routes.draw do |map|
  map.resources :entities

  map.resources :roles

  map.resources :user_sessions

  map.resources :users

  map.root :controller => 'pages', :action => 'home'
  map.about '/about', :controller => 'pages', :action => 'about'
  map.contact '/contact', :controller => 'pages', :action => 'contact'
  map.help '/help', :controller => 'pages', :action => 'help'
  
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  
  map.resources :concepts
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
