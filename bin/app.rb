# frozen_string_literal: true

require 'dotenv/load'
require_relative '../app/vacancy_pars'
require_relative '../app/db'

Database.connect_db

unless ActiveRecord::Base.connection.table_exists?('vacancies')
  ActiveRecord::Base.connection.create_table :vacancies do |t|
    t.string :title
    t.text :description
    t.string :url
    t.string :location
    t.string :apply_link
    t.timestamps
  end
end

Scraper.call

puts "Total Vacancies: #{Vacancy.count}"
