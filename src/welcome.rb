require 'sinatra/base'

class Reforestanding < Sinatra::Base
  get '/' do
    haml :index
  end
  post '/contact' do
    # save contact info
    # render thankyou page. haml :thank_you
    haml :thank_you
  end
end
