require 'dotenv/load'
require_relative 'vacancy_pars'

scraper = Scraper.new
scraper.call

puts "Total Vacancies: #{Vacancy.count}"