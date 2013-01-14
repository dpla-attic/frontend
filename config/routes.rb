DplaPortal::Application.routes.draw do
  root to: 'pages#home'

  scope 'about', as: :about do
    match 'overview',       to: 'pages#overview'
    match 'leadership',     to: 'pages#leadership'
    match 'workstreams',    to: 'pages#workstreams'
    match 'for-developers', to: 'pages#for_developers', as: 'for_developers'
    match 'get-involved',   to: 'pages#get_involved',   as: 'get_involved'
    root to: redirect('/about/overview')
  end

  resources :items, path: 'item', only: :show do
    get :search, on: :collection
  end
end
