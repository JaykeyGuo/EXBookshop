Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'welcome#index'

  namespace :admin do
    resources :products
    resources :exbooks

    resources :orders do
      member do
        post :cancel
        post :ship
        post :shipped
        post :return
      end
    end

    resources :exorders do
      member do
        post :cancel
        post :exchange
        post :chose
        post :checked
      end
    end
  end

  resources :products do
    member do
      post :add_to_cart
    end
  end

  resources :carts do
    collection do
      delete :clean
       post :checkout
    end
  end

  resources :cart_items do
    member do
      post :add_quantity
      post :remove_quantity
    end
  end

  resources :orders do
    member do
      post :pay_with_alipay
      post :pay_with_wechat
      post :apply_to_cancel
    end
  end

  namespace :account do
    resources :orders
    resources :groups
    resources :posts
    resources :exorders
  end

  resources :groups do
    member do
      post :join
      post :quit
    end
    resources :posts
  end

  resources :exbooks do
    member do
      post :add_to_list
    end
  end

  resources :lists do
    collection do
      delete :clean
      post :checkout
    end
  end

  resources :list_items do
    member do
      post :add_quantity
      post :remove_quantity
    end
  end

  resources :exorders do
    member do
      post :exchange_with_meet
      post :exchange_with_online
      post :apply_to_cancel
    end
  end
end
