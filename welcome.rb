require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/base'
require 'active_record'
require 'haml'
require 'pony'

dbconfig = YAML.load(File.read('config/database.yml'))

RACK_ENV ||= 'development'

ActiveRecord::Base.establish_connection dbconfig[RACK_ENV]

class Contact < ActiveRecord::Base
  validates_presence_of :nombre, :email, :message => "no puede estar vacio/ "
  validates_uniqueness_of :email, :twitter, :message => "ya registrado/ "
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ , :message => "no valido/ "
end
  get '/' do   
    haml :index
  end

  get '/contact' do
    haml :index
  end

  post '/contact' do
    @info = Contact.create(:nombre => params[:nombre], :email => params[:email], :twitter => params[:twitter]) 
    if @info.valid?
      Pony.mail(
        :to => 'ignacio.galindo@crowdint.com',
        :via => :smtp,
        :via_options => {
          :address => 'smtp.gmail.com',
          :port => '587',
          :enable_starttls_auto => true,
          :user_name => 'joigama@gmail.com',
          :password => '',
          :authentication => :plain,
          :domain => "HELO"
        },
        :subject => 'Hi',
        :body => 'Hello there.')
      haml :thank_you
    else
      @errors = true
      haml :index
    end
  end
