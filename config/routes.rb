DplaPortal::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :confirmations => "confirmations" }

  scope 'about', as: :about, via: :get do
    match 'overview',       to: 'pages#overview'
    match 'leadership',     to: 'pages#leadership'
    match 'workstreams',    to: 'pages#workstreams'
    match 'for-developers', to: 'pages#for_developers', as: 'for_developers'
    match 'get-involved',   to: 'pages#get_involved',   as: 'get_involved'
    root to: redirect('/about/overview')
  end

  get '/item/:id',       to: 'items#show', as: 'item'
  get '/search',         to: 'items#search', as: 'search_items'
  get '/timeline',       to: 'timeline#decades', as: 'timeline_decades'
  get '/timeline/:year', to: 'timeline#year', as: 'timeline_year', year: /\d{1,4}/

  root to: 'pages#home'
  match '/welcome' => 'users#welcome'
  
end
