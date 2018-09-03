Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root :to => 'static#home'


  resources :recipients, only: [:index, :new]
  post "recipients/add_recipient" => 'recipients#add_recipient'
  get "recipients/add_payment" => 'recipients#add_payment'
  post "recipients/make_payment" => 'recipients#make_payment'
  get "recipients/get_payments" => 'recipients#get_payments'
  post "recipients/verify_payment" => 'recipients#verify_payment'



end
