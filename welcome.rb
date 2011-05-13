require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'active_record'
require 'haml'




dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig['production']


class Contact < ActiveRecord::Base
	validates_presence_of :nombre, :email, :message => "no puede estar vacio. "
	validates_uniqueness_of :email, :twitter, :message => "ya registrado. "
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ , :message => "no valido. "
end
	get '/' do   
		haml :index
	end

	post '/contact' do
		@info = Contact.new(:nombre => params[:nombre], :email => params[:email], :twitter => params[:twitter]) 
		if @info.save
				haml :thank_you
			else
				@errors = true
				haml :index
		end
	end




