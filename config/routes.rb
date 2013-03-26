DplaPortal::Application.routes.draw do
  devise_for :users, controllers: {
    :registrations => "registrations",
    :confirmations => "confirmations",
    :sessions      => "sessions",
    :passwords     => "passwords"
  }

  scope 'about', as: :about, via: :get do
    match 'overview',       to: 'pages#overview'
    match 'leadership',     to: 'pages#leadership'
    match 'workstreams',    to: 'pages#workstreams'
    match 'for-developers', to: 'pages#for_developers', as: 'for_developers'
    match 'get-involved',   to: 'pages#get_involved',   as: 'get_involved'
    root to: redirect('/about/overview')
  end

  get '/item/:id', to: 'items#show', as: 'item'

  scope only: :show do
    resource :search,   controller: :search
    resource :timeline, controller: :timeline
    resource :map,      controller: :map
  end

  scope '/saved' do
    resources :saved_searches, path: 'searches', only: [:index, :create, :destroy] do
      post 'destroy_bulk', on: :collection
    end
    resources :saved_lists, path: 'lists'
    resources :saved_items, path: 'items', only: :destroy do
      get :unlisted, to: 'saved_lists#unlisted', on: :collection
    end
  end

  match '/welcome' => 'users#welcome'
  root to: 'pages#home'
end
