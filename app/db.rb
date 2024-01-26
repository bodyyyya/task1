require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  database: 'parsing',
  user: 'bodya',
  password: 'bodya1'
)