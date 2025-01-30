Rails.application.routes.draw do
    post 'zoom/create_meeting', to: 'zoom#create_meeting'
    get 'zoom/list_meetings', to: 'zoom#list_meetings'
    post 'zoom/add_user', to: 'zoom#add_user'
    post 'zoom/webhook', to: 'zoom#webhook'
end