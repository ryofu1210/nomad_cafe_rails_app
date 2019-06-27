Rails.application.routes.draw do
  root 'stores#index'
  resources :stores, only: %w(index show new edit create update destroy) do
    resources :favorites, only: %w(create destroy)
  end
  resources :users, only: %w(show), constraints: { id: /[0-9]+/ }

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords:     'users/passwords',
    registrations: 'users/registrations',
    sessions:      'users/sessions'
  }

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
