require 'rake'
require 'sinatra/activerecord/rake'

def database_settings
  YAML.load_file('config/database.yml')[ENV['SINATRA_ENV']]
end



