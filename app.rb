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
  
  # Turn the hash of index => attributes into a nice shiny array.
  questionnaire = params['sections'].map do |i, section|
    section['collection'] = section['collection'].map {|i, question| question } if section.has_key?("collection")
    section
  end 
  
  File.open("store/#{filename}.json", 'w') do |file|
    file << questionnaire.to_json
  end
  
  'OK'
end