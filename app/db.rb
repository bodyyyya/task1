require 'active_record'
class Database
  def self.connect
    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      host: 'localhost',
      database: ENV['DATABASE'],
      username: ENV['DATABASE_USERNAME'] ,
      password: ENV['DATABASE_PASSWORD']
    )
  end

  def self.connect_db
    self.connect
  end
end