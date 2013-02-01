DplaPortal::Application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations", :confirmations => "confirmations" }

  scope 'about', as: :about do
    match 'overview',       to: 'pages#overview'
    match 'leadership',     to: 'pages#leadership'
    match 'workstreams',    to: 'pages#workstreams'
    match 'for-developers', to: 'pages#for_developers', as: 'for_developers'
    match 'get-involved',   to: 'pages#get_involved',   as: 'get_involved'
    root to: redirect('/about/overview')
  end

  resources :items, only: :show, path: 'item', id: /.*/ do
    get :search, on: :collection
  end

  root to: 'pages#home'
  match '/welcome' => 'users#welcome'
  
end
