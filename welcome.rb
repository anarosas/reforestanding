require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'activerecord'
require 'haml'



dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig['production']

class Contact < ActiveRecord::Base
	validates_presence_of :name, :email
	validates_uniqueness_of :email, :twitter
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ , :message => "Correo no valido"

	get '/' do   
		haml :index
	end

	post '/contact' do
		@info = Contact.new(:name => params[:name], :email => params[:email], :twitter => params[:twitter]) 
		if @info.save
				haml :thank_you
			else
				haml :index
		end
	end

end


