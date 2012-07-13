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

  filename = "store/#{@trkref}-#{@product_name}.json"
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
    return section unless section.has_key?("collection")
    section['collection'] = section['collection'].map do |i, question|
      question['answers'] = question['answers'].values if question.has_key?('answers')
      question
    end
    section
  end

  File.open("store/#{filename}.json", 'w') do |file|
    file << questionnaire.to_json
  end

  'OK'
end