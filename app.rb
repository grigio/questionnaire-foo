require 'sinatra'

get '/questionnaire/new' do
  erb :"questionnaire/new"
end

post '/questionnaire' do
  raise params.to_yaml
end