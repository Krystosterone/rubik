require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web, at: "/sidekiq"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :comments, only: [:new, :create]
  resources :donations, only: [:new, :create]
  resources :terms, only: :index
  resources :academic_degree_terms, only: [] do
    resources :agendas, param: :token, shallow: true do
      resources :schedules, only: :index do
        get :processing, on: :collection
      end
    end
  end

  ErrorsController::MAPPED_ERRORS.each do |status, code|
    get "/#{code}", to: "errors##{status}"
  end

  root 'terms#index'
end
