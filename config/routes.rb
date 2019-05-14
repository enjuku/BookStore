Rails.application.routes.draw do
  
  root   'static_page#home'

  resources :books
 
  match 'login',                 to: 'users#login',             as: 'login',             via: [:get, :post]
  match 'logout',                to: 'users#logout',            as: 'logout',            via: [:get, :post]
  match 'signup',                to: 'users#signup',            as: 'signup',            via: [:get, :post]
  match 'account',               to: 'users#account',           as: 'account',           via: [:get, :post]
  match 'account/destroy',       to: 'users#destroy',           as: 'destroy',           via: [:get, :post]

  match 'lost_password',         to: 'users#lost_password',     as: 'lost_password',     via: [:get, :post]
  match 'password_recovery/:id', to: 'users#password_recovery', as: 'password_recovery', via: [:get, :post, :patch]

  scope module: 'admin' do
    resources :users
    resources :genres
    resources :authors
  end

  get '*unmatched_route', to: 'application#render_404'

end
