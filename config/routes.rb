Rails.application.routes.draw do
  get 'ads', to: 'page#ads'
  get 'ad_new', to: 'page#ad_new'
  post 'ad_create', to: 'page#ad_create'
  get 'api', to: 'api#test'
  get 'ad_request', to: 'page#ad_request'
  get 'analytics', to: 'api#analytics'
  get 'report', to: 'page#report'
  get 'show/:id', to: 'page#ad_show'
  get 'delete/:id', to: 'page#ad_delete'
  root to: 'page#index'
end
