require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web, at: "/sidekiq"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :comments, only: [:new, :create]
  resources :terms, only: :index
  resources :academic_degree_terms, only: [] do
    resources :agendas, except: :show, param: :token, shallow: true do
      get "/", to: redirect("/agendas/%{agenda_token}/schedules", 302)

      resources :schedules, only: :index, constraints: -> (r) { r.params.fetch(:page, "1") =~ /^[1-9]\d*$/ } do
        get :processing, on: :collection
      end
    end
  end

  resources :agendas, param: :token, only: [] do
    resources :schedules, only: :show, param: :index, constraints: { index: /[1-9]\d*/ }
  end

  ErrorsController::MAPPED_ERRORS.each do |status, code|
    get "/#{code}", to: "errors##{status}"
  end

  root "terms#index"
end
