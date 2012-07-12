require 'sinatra'
require 'json'

get '/questionnaire' do
  @existing_templates = Dir.glob('store/*-*.json').map do |filename| 
    filename.sub("store/", '').sub('.json', '').split('-')
  end
  erb :"questionnaire/index"
end

get '/questionnaire/new' do
  if params[:trkref] || params[:product_name]
    @trkref = params[:trkref]
    @product_name = params[:product_name].sub(' ', '_').downcase
  end
  
  filename = "store/#{@trkref}-#{@product_name}"
  if File.exist?(filename)
    @template = File.read(filename) 
  else
    @template = File.read('store/default.json')
  end
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