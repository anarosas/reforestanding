require 'rubygems'
require File.join(File.dirname(__FILE__), 'welcome.rb')

require 'activerecord'

dbconfig = YAML.load(File.read('config/database.yml'))
ActiveRecord::Base.establish_connection dbconfig['production']

run Reforestanding
