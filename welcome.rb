require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'haml'

class Contact < ActiveRecord::Base
end

  get '/' do   
		haml :index, :layout => false
  end

  post '/contact' do
		@info = Contact.new(:name => params[:name], :email => params[:email], :twitter => params[:twitter])
		if @info.save
				haml :thank_you
			else
				haml :index
		end
  end
