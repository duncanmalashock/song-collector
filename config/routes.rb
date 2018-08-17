Rails.application.routes.draw do
  root to: 'pages#main'
  
  get '/auth/spotify/callback', to: 'users#spotify'
end
