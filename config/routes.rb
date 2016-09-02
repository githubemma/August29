Rails.application.routes.draw do

  devise_for :users
  devise_for :admins

  controller :login do
    get 'create_default' => :create_default
    get 'get_article' => :get_article
  end

  controller :comment do
    get 'admin/comment' => :index
    post 'admin/comment/change_status' => :change_status
    post 'admin/comment/edit_comment' => :edit_comment
    post 'admin/comment/delete_comment' => :delete_comment
    post 'admin/comment/change_request_page_status' => :change_request_page_status
    post 'admin/comment/delete_page_request' => :delete_page_request
  end

  controller :admin do
    get 'admin/admin' => :index
    post 'admin/admin/save_admin' => :save_admin
    post 'admin/admin/delete_admin' => :delete_admin
  end

  controller :suggest do
    get 'admin/suggest' => :index
    post 'admin/suggest/accept_all' => :accept_all
    post 'admin/suggest/decline_all' => :decline_all
    post 'admin/suggest/decline' => :decline
    post 'admin/suggest/accept' => :accept
    post 'admin/suggest/clear_history' => :clear_history
  end

  controller :report do
    get 'admin/report' => :index
    post 'admin/report/ignore' => :ignore
    post 'admin/report/delete' => :delete
    post 'admin/report/clear_history' => :clear_history
  end

  controller :slider do
    get 'admin/slider' => :index
    post 'admin/slider/save_slider' => :save_slider
    post 'admin/slider/save_slider_images' => :save_slider_images
    post 'admin/slider/delete_slider_image' => :delete_slider_image
    post 'admin/slider/delete_slider' => :delete_slider
    get 'admin/slider/get_images' => :get_images
    get 'admin/slider/get_pages' => :get_pages
    post 'admin/slider/assign_sliders' => :assign_sliders
    post 'admin/slider/crop_image' => :crop_image
  end

  controller :page do
    get 'admin/page' => :index
    post 'admin/page/save_item' => :save_item
    post 'admin/page/delete_item' => :delete_item
    post 'admin/page/save_column' => :save_column
    post 'admin/page/delete_column' => :delete_column
    post 'admin/page/delete_page' => :delete_page
    post 'admin/page/save_page' => :save_page
    get 'admin/page/get_page_content' => :get_page_content
    post 'admin/page/save_page_content' => :save_page_content
    get 'admin/page/get_links' => :get_links
    post 'admin/page/save_quick_links' => :save_quick_links
    post 'admin/page/delete_quick_link' => :delete_quick_link
    post 'admin/page/delete_folder' => :delete_folder
    post 'admin/page/save_folder' => :save_folder
    post 'admin/page/add_page_to_folder' => :add_page_to_folder
    post 'admin/page/remove_page_from_folder' => :remove_page_from_folder
    get 'admin/page/get_twitter_feed' => :get_twitter_feed
    post 'admin/page/delete_twitter_feed' => :delete_twitter_feed
    post 'admin/page/save_twitter_feed' => :save_twitter_feed
    get 'admin/page/get_item_pages' => :get_item_pages
    post 'admin/page/copy_item' => :copy_item
  end

  controller :homepage do
    get 'admin' => :index
    post 'admin/homepage/save_category' => :save_category
    post 'admin/homepage/delete_category' => :delete_category
    get 'admin/homepage/get_homepage_content' => :get_homepage_content
    post 'admin/homepage/save_homepage_content' => :save_homepage_content
  end

  controller :article do
    get 'admin/article' => :index
    get 'admin/get_article' => :get_article
    post 'admin/article/save_article' => :save_article
  end

  controller :welcome do
    post 'request_page' => :request_page
  end

  controller :individual_page do
    get 'page/:id' => :index
    get ':id' => :index
    post 'page/report_content' => :report_content
    post 'page/suggest_item' => :suggest_item
    post 'page/suggest_column' => :suggest_column
    post 'page/send_message' => :send_message
    post 'page/add_bookmark' => :add_bookmark
    post 'page/remove_bookmark' => :remove_bookmark
    post 'page/share_by_email' => :share_by_email
  end

  controller :user do
    get 'admin/user' => :index
    get 'admin/user/get_user_bookmarks' => :get_user_bookmarks
  end

  controller :content do
    get 'admin/content' => :index
    post 'admin/content/export_content' => :export_content
    post 'admin/content/import_content' => :import_content
    post 'admin/content/delete_content' => :delete_content
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'welcome#index'

  # get '*path' => redirect('/')

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
