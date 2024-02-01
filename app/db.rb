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

  def self.create_vacancies_table
    ActiveRecord::Base.connection.create_table :vacancies do |t|
      t.string :title
      t.text :description
      t.string :url
      t.string :location
      t.string :apply_link
      t.timestamps
    end
  end
end