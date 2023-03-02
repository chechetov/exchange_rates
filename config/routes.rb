Rails.application.routes.draw do
  devise_for :users

root 'rates#convert'

get  'rates/series'
get  'rates/convert'
post 'rates/get_series'
post 'rates/convert_amount'

get  'admin/list_currencies'
get  'admin/get_currencies'
get  'admin/save_currencies'
get  'admin/delete_currencies'

get  'admin/index'
get  'admin/view_config'
get  'admin/update_config'
post 'admin/save_config'

get  'api/currencies'
get  'api/series'
post 'api/convert'

end
