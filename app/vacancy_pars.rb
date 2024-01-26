require 'nokogiri'
require 'httparty'
require 'dotenv'
require_relative 'db'
require_relative 'vacancy'
Dotenv.load('.env', 'test.env')

class Scraper
  def initialize
    Dotenv.load(File.expand_path('../.env', __FILE__), File.expand_path('../test.env', __FILE__))
    create_vacancies_table unless ActiveRecord::Base.connection.table_exists?(:vacancies)
  end

  def call
    base_url = ENV['OPENAI_CAREERS_URL']
    response = HTTParty.get(base_url)

    handle_empty_response_body(response.body)

    doc = Nokogiri::HTML(response.body)
    vacancy_links = doc.css('.job-listing-title a').map { |link| link['href'] }

    vacancy_links.each do |link|
      scrape_individual_vacancy("https://openai.com#{link}")
    end
  end

  private

  def create_vacancies_table
    ActiveRecord::Base.connection.create_table :vacancies do |t|
      t.string :title
      t.text :description
      t.string :url
      t.string :location

      t.timestamps
    end
  end

  def handle_empty_response_body(body)
    if body.nil? || body.empty?
      puts 'Error: Empty response body'
      exit
    end
  end

  def scrape_individual_vacancy(vacancy_url)
    vacancy_response = HTTParty.get(vacancy_url)
    handle_empty_response_body(vacancy_response.body)

    vacancy_doc = Nokogiri::HTML(vacancy_response.body)

    title = vacancy_doc.css('.f-display-2').text.strip
    description = vacancy_doc.css('.ui-description').text.strip
    location = vacancy_doc.css('.f-subhead-1').text.strip

    save_vacancy_to_database(title, description, vacancy_url, location)

    puts "Vacancy '#{title}' saved to the database."
  end

  def save_vacancy_to_database(title, description, url, location)
    Vacancy.create(
      title: title,
      description: description,
      url: url,
      location: location
    )
  end
end