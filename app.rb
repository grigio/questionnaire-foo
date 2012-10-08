# encoding: utf-8
require 'sinatra'
#require 'sinatra/reloader' if development?
require 'bcrypt'
require 'json'
require 'rack/env'

use Rack::Env # load .env variables

# Basic configs

configure :development do
  enable :logging, :dump_errors, :raise_errors
end
set :show_exceptions, true if development?

if production?
  logger = ::File.open(ENV['OPENSHIFT_DATA_DIR']+"store/production.log", "a+")
  STDOUT.reopen(logger)
  STDERR.reopen(logger)
  use Rack::CommonLogger, logger
end

helpers do

  def protected!
    unless authorized?
      response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
      throw(:halt, [401, "Authentication failed\n"])
    end
  end

  def authorized?
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    #@auth.provided? && @auth.basic? && @auth.credentials && @auth.credentials == ['admin', 'admin']
    @auth.provided? && @auth.basic? && @auth.credentials &&
      BCrypt::Password.new(ENV['PASSWD_CRYPT']) == @auth.credentials[1]
  end

end

###

get '/' do
  redirect ENV['HOME_URL'] || '/questionnaire'
end

# show form
get '/questionnaire/view' do
  if params[:trkref] || params[:product_name]
    @trkref = params[:trkref]
    @product_name = params[:product_name].sub(' ', '_').downcase
  end

  filename = "store/#{@trkref}-#{@product_name}.json"
  if File.exist?(filename)
    @template = File.read(ENV['OPENSHIFT_DATA_DIR']+filename)
  else
    @template = File.read(ENV['OPENSHIFT_DATA_DIR']+'store/default.json')
  end
  erb :"questionnaire/view"
end

# write form data
post '/questionnaire/submit' do
  timestamp = Time.now.to_i.to_s
  File.open(ENV['OPENSHIFT_DATA_DIR']+"store/results/res-#{timestamp}.json", 'w') do |file|
    file << JSON.pretty_generate(params)
  end

  res = <<ERB
    <h1>Congratulazioni :)</h1>
    <p>
      Il tuo questionario è stato registrato con codice #{timestamp}
    </P>
ERB

end

# index list
get '/questionnaire' do
  protected!
  @existing_templates = Dir.glob(ENV['OPENSHIFT_DATA_DIR']+'store/*-*.json').map do |filename|
    filename.sub("store/", '').sub('.json', '').split('-')
  end
  erb :"questionnaire/index"
end

get '/questionnaire/new' do
  protected!
  if params[:trkref] || params[:product_name]
    @trkref = params[:trkref]
    @product_name = params[:product_name].sub(' ', '_').downcase
  end

  filename = "store/#{@trkref}-#{@product_name}.json"
  if File.exist?(ENV['OPENSHIFT_DATA_DIR']+filename)
    @template = File.read(ENV['OPENSHIFT_DATA_DIR']+filename)
  else
    @template = File.read(ENV['OPENSHIFT_DATA_DIR']+'store/default.json')
  end
  erb :"questionnaire/new"
end

# check env variables
get '/secrets' do
  protected!
  erb ENV.map{|e|e[0]+": "+e[1]}.join("<br>\n")
end

# write form schema
post '/questionnaire' do
  protected!
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

  File.open(ENV['OPENSHIFT_DATA_DIR']+"store/#{filename}.json", 'w') do |file|
    file << JSON.pretty_generate(questionnaire)
  end

  'OK'
end