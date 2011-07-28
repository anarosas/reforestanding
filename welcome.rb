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
  #validates_uniqueness_of :email, :twitter, :message => "ya registrado/ "
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ , :message => "no valido/ "
end
  get '/' do   
    haml :index
  end

  get '/contact' do
    haml :index
  end

  post '/contact' do
    mail_body = File.read("views/mail.html")  
    @info = Contact.create(:nombre => params[:nombre], :email => params[:email], :twitter => params[:twitter]) 
    if @info.valid?
      Pony.mail(
        :to => @info.email,
        :via => :smtp,
        :via_options => {
          :address => 'smtp.gmail.com',
          :port => '587',
          :enable_starttls_auto => true,
          :user_name => 'social@crowdint.com',
          :password => 's0c14lm3d14',
          :authentication => :plain,
          :domain => "crowdint.com"
        },
        :subject => "Reforestanding Colima!!  Welcome #{@info.nombre}",
        :html_body => mail_body,
        :body => "Gracias por registrarte. Pronto te informaremos sobre los eventos. Saludos.")
      haml :thank_you
    else
      @errors = true
      haml :index
    end
  end
