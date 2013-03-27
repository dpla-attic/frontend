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
    resources :saved_lists, path: 'lists', id: /\d/ do
      get 'unlisted', action: :show, on: :collection
    end
    scope '/lists' do
      post   'add_item',    to: 'saved_lists#add_item',    as: :add_saved_item
      delete 'remove_item', to: 'saved_lists#remove_item', as: :remove_saved_item
    end
  end

  match '/welcome' => 'users#welcome'
  root to: 'pages#home'
end
