require 'sinatra'
require 'json'

get '/questionnaire/new' do
  @default_template = File.read('store/default.json')
  erb :"questionnaire/new"
end

post '/questionnaire' do
  trkref = params.delete('trkref')
  product = params.delete('product')

  filename = [trkref, product.downcase.sub(' ', '_')].compact.join('-')

  raise params.to_yaml

  File.open("store/#{filename}.json", 'w') do |file|
    file << params.to_json
  end

  'OK'
end