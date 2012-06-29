require 'sinatra'

get '/new' do
  erb :"questionnaire/new"
end