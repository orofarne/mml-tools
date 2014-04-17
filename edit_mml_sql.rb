#!/usr/bin/env ruby

require 'json'
require 'sinatra'

def gen_json(doc)
	JSON.pretty_generate(doc).gsub(/{\s*}/, '{}')
end

def save_data(file, doc)
	data = gen_json(doc)

	File.open(file, 'w') { |file|
		file.write data
	}
end

if ARGV.length == 0 then
	$stderr.puts "Usage: edit_mml_sql.rb <mml_file>"
	exit 1
end

title = /[^\/]+$/.match(ARGV[0]).to_s

f = File.open ARGV[0]
doc = JSON.parse IO.read(f)
f.close

set :haml, {:format => :html5, :attr_wrapper => '"'}

get '/' do
	haml :index, :locals => {:doc => doc, :layer => nil, :title => title}
end

get '/edit/:layer' do |layer|
	layer_data = doc['Layer'].select{ |l| l['name'] == layer }.first
	haml :edit, :locals => {:layer => layer_data, :title => title}
end

post '/edit/:layer' do |layer|
	layer_data = doc['Layer'].select { |l| l['name'] == layer }.first
	query = request.body.read.to_s.force_encoding("UTF-8")

	layer_data['Datasource']['table'] = query
	save_data(ARGV[0], doc)

	redirect '/'
end
