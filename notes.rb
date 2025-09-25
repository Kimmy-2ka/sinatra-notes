# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'dotenv/load'

# Description of Note class
# PostgreSQLを用いてデータの読込、新規追加、検索、編集、削除の機能を有する。
class Note
  CONN = PG.connect(
    host: ENV['HOST'],
    dbname: ENV['DBNAME'],
    user: ENV['DBUSER'],
    password: ENV['PASSWORD']
  )
  attr_reader :id, :title, :content

  def initialize(note)
    @id = note[:id]
    @title = note[:title]
    @content = note[:content]
  end

  def self.all_notes
    notes = CONN.exec('SELECT id, title, content FROM notes ORDER BY id')
    notes.map { |note| note.transform_keys(&:to_sym) }
  end

  def self.create(title, content)
    CONN.exec_params('INSERT INTO notes (title, content) VALUES ($1, $2)', [title, content])
  end

  def self.find(id)
    note = CONN.exec_params('SELECT id, title, content From notes Where id=$1', [id.to_i]).first
    Note.new(note.transform_keys(&:to_sym)) if note
  end

  def edit(title, content)
    CONN.exec_params('UPDATE notes SET title = $1, content = $2 WHERE id=$3', [title, content, @id])
  end

  def delete
    CONN.exec_params('DELETE FROM notes WHERE id=$1', [@id])
  end
end

helpers do
  def escape(text)
    Rack::Utils.escape_html(text)
  end
end

get '/' do
  redirect '/notes'
end

not_found do
  @title = 'Entry is not found'
  erb :not_found
end

get '/notes' do
  @title = 'メモアプリ'
  @notes = Note.all_notes
  erb :index
end

get '/notes/new' do
  @title = '新規作成'
  erb :new
end

post '/notes' do
  Note.create(params[:title], params[:content])
  redirect '/notes'
end

get '/notes/:id' do
  @note = Note.find(params[:id])
  if @note
    @title = @note.title
    erb :detail
  else
    halt 404
  end
end

get '/notes/:id/edit' do
  @note = Note.find(params[:id])
  @title = "編集 #{@note.title}"
  erb :edit
end

patch '/notes/:id' do
  @note = Note.find(params[:id])
  @note.edit(params[:title], params[:content])
  redirect '/notes'
end

delete '/notes/:id' do
  @note = Note.find(params[:id])
  @note.delete
  redirect '/notes'
end
