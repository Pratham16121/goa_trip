Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "employees", to: "employees#index" 

  put "booking", to: "employees#update"

  get "empdetails", to: "employees#fetch_details"

end
