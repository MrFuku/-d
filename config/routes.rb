Rails.application.routes.draw do
  get 'ads', to: 'page#ads'
  get 'ad_new', to: 'page#ad_new'
  post 'ad_create', to: 'page#ad_create'
  root to: 'page#index'
end
