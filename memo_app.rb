# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'securerandom'
require 'rack/protection'

enable :method_override
use Rack::Protection

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

def store_memo(filename, title, body)
  memos = JSON.parse(File.read(filename), symbolize_names: true)
  memos << { id: SecureRandom.uuid, title: title, body: body }
  File.write(filename, JSON.pretty_generate(memos))
  memos.last
end

def read_memo_list
  File.open('memo_list.json', 'a') { |file| file.puts '[]' } unless File.exist?('memo_list.json')
  JSON.parse(File.read('memo_list.json'), symbolize_names: true)
end

def delete_memo(filename, id)
  memos = JSON.parse(File.read(filename))
  memos.reject! { |memo| memo[:id] == id }
  File.write(filename, JSON.pretty_generate(memos))
end

before do
  @memos = read_memo_list
end

before '/memos/:id*' do
  # '/memos/new' の場合はフィルターをスキップし、それ以外はメモを探して見つからなければ 404 を返す
  pass if params[:id] == 'new'
  @memo = @memos.find { |memo| memo[:id] == params[:id] }
  halt 404, erb(:not_found) unless @memo
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memo = store_memo('memo_list.json', params[:title], params[:body])
  redirect "/memos/#{memo[:id]}"
end

get '/memos/:id' do
  erb :show
end

get '/memos/:id/edit' do
  erb :edit
end

patch '/memos/:id' do
  @memo[:title] = params[:title]
  @memo[:body]  = params[:body]
  File.write('memo_list.json', JSON.pretty_generate(@memos))
  redirect "/memos/#{@memo[:id]}"
end

delete '/memos/:id' do
  delete_memo('memo_list.json', @memo[:id])
  redirect '/'
end

not_found do
  erb :not_found
end
