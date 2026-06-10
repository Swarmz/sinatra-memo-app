# frozen_string_literal: true

require 'sinatra'
require 'rack/protection'
require 'pg'

DB = PG.connect(
  dbname: ENV.fetch('MEMO_APP_DB_NAME', 'memo_app'),
  user: ENV.fetch('MEMO_APP_DB_USER', ENV['USER']),
  password: ENV['MEMO_APP_DB_PASSWORD']
)

DB.exec <<~SQL
  CREATE TABLE IF NOT EXISTS memos (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL
  );
SQL

enable :method_override
use Rack::Protection

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

def create_memo(title, body)
  rows = DB.exec_params(
    'INSERT INTO memos (title, body) VALUES ($1, $2) RETURNING id;',
    [title, body]
  )
  rows.first['id']
end

def all_memos
  DB.exec('SELECT id, title, body FROM memos ORDER BY id;')
end

def find_memo(id)
  rows = DB.exec_params(
    'SELECT id, title, body FROM memos WHERE id = $1 LIMIT 1;',
    [id]
  )
  rows.first
end

def update_memo(id, title, body)
  DB.exec_params(
    'UPDATE memos SET title = $1, body = $2 WHERE id = $3;',
    [title, body, id]
  )
end

def delete_memo(id)
  DB.exec_params('DELETE FROM memos WHERE id = $1;', [id])
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = all_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memo_id = create_memo(params[:title], params[:body])
  redirect "/memos/#{memo_id}"
end

get '/memos/:id' do
  @memo = find_memo(params[:id])
  halt 404, erb(:not_found) unless @memo
  erb :show
end

get '/memos/:id/edit' do
  @memo = find_memo(params[:id])
  halt 404, erb(:not_found) unless @memo
  erb :edit
end

patch '/memos/:id' do
  halt 404 unless find_memo(params[:id])
  update_memo(params[:id], params[:title], params[:body])
  redirect "/memos/#{params[:id]}"
end

delete '/memos/:id' do
  halt 404 unless find_memo(params[:id])
  delete_memo(params[:id])
  redirect '/memos'
end

not_found do
  erb :not_found
end
