# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'

# Description of Note class
# JSONファイルの読込・保存・追加・編集・削除する機能を有する。
class Note
  attr_reader :id, :title, :content

  def initialize(target_note)
    @id = target_note[:id]
    @title = target_note[:title]
    @content = target_note[:content]
  end

  def self.load
    JSON.parse(File.read('notes.json'), symbolize_names: true)
  end

  def self.visible_notes
    load.reject { |note| note[:delete] }
  end

  def self.save(notes)
    File.open('notes.json', 'w') do |file|
      JSON.dump(notes, file)
    end
  end

  def self.create(title, content)
    notes = load
    notes << { id: notes.size, title:, content:, delete: false }
    save(notes)
  end

  def self.find(id)
    target_note = visible_notes.find { |note| note[:id] == id.to_i }
    Note.new(target_note) if target_note
  end

  def edit(title, content)
    notes =
      Note.load.map do |note|
        if note[:id] == @id
          note.merge(title: title, content: content)
        else
          note
        end
      end
    Note.save(notes)
  end

  def delete
    notes =
      Note.load.map do |note|
        note[:id] == @id ? note.merge(delete: true) : note
      end
    Note.save(notes)
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
  @notes = Note.visible_notes
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
