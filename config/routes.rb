SouFudao::Application.routes.draw do

  resources :paypal_payments do
    collection do
      get '/featured_payment/:id' => "paypal_payments#featured_payment"
      get '/featured_payment_monthly' => "paypal_payments#featured_payment_monthly"
      get '/featured_payment_yearly' => "paypal_payments#featured_payment_yearly"
      get '/review/:id' => "paypal_payments#review"
      get '/cancel/:id' => "paypal_payments#cancel"      
      get '/cancel_recurring/:id' => "paypal_payments#cancel_recurring"            
      get '/make_recurring' => "paypal_payments#make_recurring"
      get '/notification/:payment_id' => "paypal_payments#notification"
      #post '/request_to_yoopay' => "subscriptions#request_to_yoopay"
    end
  end


  resources :user_details do
    collection do
      get 'update_password'
      get '/:id/profile_completion_step2' => 'user_details#profile_completion_step2'
      post '/:id/update_user_details' => 'user_details#update_user_details'
      put '/update_profile_visibility/:id' => 'user_details#update_profile_visibility'
      put '/email_updates_flag/:id' => 'user_details#email_updates_flag'

      patch '/save_user_avatar/:id' => "user_details#save_user_avatar"
      get '/remove_user_avatar/:id' => "user_details#remove_user_avatar"
      post '/:id/update_user_subjects' => 'user_details#update_user_subjects'
      post '/:id/update_user_info' => 'user_details#update_user_info'
      post '/:id/update_phone_info' => 'user_details#update_phone_info'

      get '/:id/profile_completion_step3' => 'user_details#profile_completion_step3'
      get '/save_listing_type/:id' => 'user_details#save_listing_type'
      get '/my_account/:id' => 'user_details#my_account'
      post '/:id/update_availability_info' => 'user_details#update_availability_info'
      post '/:id/update_location_details' => 'user_details#update_location_details'

      post '/save_user_avatar/:id' => "user_details#save_user_avatar"

      get 'add_time_select' => "user_details#add_time_select"
      get 'add_distance_select' => "user_details#add_distance_select"
      post '/invite_a_friend/:id' => "user_details#invite_a_friend"
      get 'add_more_degree' => "user_details#add_more_degree"
      get 'get_districts' => "user_details#get_districts"
    end
  end

  resources :tutors do
    collection do 
      get 'tutor/:id' => 'tutor#profile'
      get '/my_client/:id' => 'tutors#my_client'
      get '/settings/:id' => 'tutors#settings'
      get '/upgrade/:id' => 'tutors#upgrade'
      get '/my_messages/:id' => 'tutors#my_messages'      
      post '/:id/save_tutor_message' => 'tutors#save_tutor_message'
      get '/close_account/:id' => "tutors#close_account"
      post '/:id/confirm_close_account' => 'tutors#confirm_close_account'
      get '/student_close_account/:id' => "tutors#student_close_account"
      post '/:id/student_confirm_close_account' => 'tutors#student_confirm_close_account'
      get '/account_closed_message' => 'tutors#account_closed_message'

      post '/search' => 'tutors#search'
      get '/search' => 'tutors#search'
      post '/search_list_view' => 'tutors#search_list_view'
      get '/search_list_view' => 'tutors#search_list_view'

      get '/student/:id' => 'tutors#student'
      get '/student_setting/:id' => 'tutors#student_setting'
      get '/invite_students_friend/:id' => 'tutors#invite_students_friend' 
      post '/update_student_data/:id' => 'tutors#update_student_data'
      post '/tell_a_friend/:id' => 'tutors#tell_a_friend'
      post '/save_rate_reviews/tutor_id' => 'tutors#save_rate_reviews'
      get '/reload_capcha' => 'tutors#reload_capcha'
      post '/create_student_user' => "tutors#create_student_user"
      post '/student_sign_in' => "tutors#student_sign_in"
      get '/show_msg_conversation/:other_user_id' => "tutors#show_msg_conversation"
      post '/send_message_via_ajax' => "tutors#send_message_via_ajax"
      get '/student_messages/:id' => "tutors#student_messages" 
      get '/show_msg_conversation_for_student/:other_user_id' => "tutors#show_msg_conversation_for_student"
      get '/send_saved_message' => "tutors#send_saved_message"

    end
  end

  resources :subscriptions do
    collection do
      post '/request_to_yoopay' => "subscriptions#request_to_yoopay"
    end
  end
  #post 'user_details/change_pass/:id' => 'user_details#change_pass'

  get '/home' => 'home#index', as: 'home'
  get '/page_not_found' => 'home#page_not_found', as: 'page_not_found'
  get '/about' => 'home#about', as: 'about'
  get '/faq' => 'home#faq', as: 'faq'
  get '/contact' => 'home#contact', as: 'contact'
  get '/search_tutors' => "home#search_tutors"
  get '/simple_captcha/:id', :to => 'simple_captcha#show', :as => :simple_captcha
  get '/notify_url' => 'subscriptions#notify_url'
  get '/return_url' => 'subscriptions#return_url'

  resources :home do
    collection do 
        post '/save_contact' => 'home#save_contact'
        get '/change_locale' => 'home#change_locale'
    end
  end

  devise_for :users
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#search_tutors'

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
