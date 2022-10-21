Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  
  # setting the base route to go to index controller, home view
  root to: 'index#home'
end
