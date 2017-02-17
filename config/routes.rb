# frozen_string_literal: true
require "sidekiq/web"

Rails.application.routes.draw do
  get "/auth/#{SidekiqAuthentication::AUTH_PROVIDER_NAME}/callback" => "sidekiq_sessions#create"
  get "/auth/failure", to: redirect("/401", 302)

  get "/sidekiq/signin", to: redirect("/auth/#{SidekiqAuthentication::AUTH_PROVIDER_NAME}", 302)
  get "/sidekiq/signout" => "sidekiq_sessions#destroy"

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  mount Sidekiq::Web, at: "/sidekiq"

  resources :academic_degree_terms, only: [] do
    resources :agendas, except: :show, param: :token, shallow: true do
      get "/", to: redirect("/agendas/%{agenda_token}/schedules", 302)

      resources :schedules, only: :index, constraints: ->(r) { r.params.fetch(:page, "1") =~ /^[1-9]\d*$/ } do
        get :processing, on: :collection
      end
    end
  end

  resources :agendas, param: :token, only: [] do
    resources :schedules, only: :show, param: :index, constraints: { index: /[1-9]\d*/ }
  end

  resources :comments, only: [:new, :create]

  resource :faq, only: :show

  resources :terms, only: :index do
    collection do
      post :create_newsletter_subscription
    end
  end

  ErrorsController::MAPPED_ERRORS.each do |status, code|
    get "/#{code}", to: "errors##{status}", as: status
  end

  root "terms#index"
end
