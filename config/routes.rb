Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :promotions do
  	member do
  	  post 'approve'
  	  post 'generate_coupons'
  	end
  	get 'search', on: :collection
  end
  resources :product_categories, only:[:index, :show, :new, :create, :edit, :update, :destroy]
  resources :coupons, only:[] do
    post 'disable', on: :member
  end

  namespace :api do
  	namespace :v1 do
  	  resources :promotions, only: [:create, :update, :destroy]
  	  resources :coupons, only: [:show], param: :code do
  	  	post 'disable', on: :member
  	  end
  	end
  end
end
