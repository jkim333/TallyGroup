Rails.application.routes.draw do
  root to:'bakery#index'
  post '/calculate', to: 'bakery#calculate'
end
