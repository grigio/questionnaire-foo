require 'sinatra'
require 'sinatra/reloader'
require 'json'

get '/' do
  redirect '/questionnaire'
end

# show form
get '/questionnaire/view' do
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
  erb :"questionnaire/view"
end

# write form data
post '/questionnaire/submit' do
  timestamp = Time.now.to_i.to_s
  File.open("store/results/res-#{timestamp}.json", 'w') do |file|
    file << JSON.pretty_generate(params)
  end
  erb "Inserito "+timestamp
end

# index list
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

# write form schema
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
    file << JSON.pretty_generate(questionnaire)
  end

  'OK'
end