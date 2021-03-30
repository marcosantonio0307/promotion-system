Rails.application.routes.draw do
  devise_for :users
  root 'home#index'
  resources :promotions, only:[:index, :show, :new, :create, :edit, :update, :destroy] do
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
end
