require 'nokogiri'
require 'httparty'
require 'dotenv/load'
require_relative 'db'
require_relative 'vacancy'
Dotenv.load('.env', 'test.env')
Database.connect_db

class Scraper
  attr_accessor :title, :description, :vacancy_url, :location, :apply_link

  def initialize(title = nil, description = nil, vacancy_url = nil, location = nil, apply_link = nil)
    Database.connect_db
    @title = title
    @description = description
    @vacancy_url = vacancy_url
    @location = location
    @apply_link = apply_link
    create_vacancies_table unless ActiveRecord::Base.connection.table_exists?(:vacancies)
  end

  def self.call
    scraping
  end

  def self.scraping
      base_url = ENV['OPENAI_CAREERS_URL']
      response = HTTParty.get(base_url)
      handle_empty_response_body(response.body)
      doc = Nokogiri::HTML(response.body)
      vacancy_links = doc.css('ul[aria-label="All teams roles"] li a').map { |link| link['href'] if link['href'].include?("careers")}

      vacancy_links.each do |link|
        scrape_individual_vacancy("https://openai.com#{link}")
      end
    end
  private

  def self.handle_empty_response_body(body)
    if body.nil? || body.empty?
      puts 'Error: Empty response body'
      return
    end
  end

  def self.scrape_individual_vacancy(vacancy_url)
    vacancy_response = HTTParty.get(vacancy_url)
    handle_empty_response_body(vacancy_response.body)

    vacancy_doc = Nokogiri::HTML(vacancy_response.body)

    title = vacancy_doc.css('.f-display-2').text.strip
    description = vacancy_doc.css('.ui-description').text.strip
    location = vacancy_doc.css('.f-subhead-1').text.strip
    apply_link = vacancy_doc.at_css('.lg\\:absolute.top-0.left-0.right-0.flex.flex-col a[aria-label="Apply now"]')&.[]('href')
    save_vacancy(title, description, vacancy_url, location, apply_link)

  end

  def self.save_vacancy(title, description, vacancy_url, location, apply_link)
    existing_vacancy = Vacancy.find_by(url: vacancy_url)
  
    if existing_vacancy
      update_vacancy(existing_vacancy, title, description, vacancy_url, location, apply_link)
    else
      create_vacancy(title, description, vacancy_url, location, apply_link)
    end
  end
  
  def self.update_vacancy(existing_vacancy, title, description, vacancy_url, location, apply_link)
    existing_vacancy.update(title: title, description: description, location: location, apply_link: apply_link)
  end
  
  def self.create_vacancy(title, description, vacancy_url, location, apply_link)
    Vacancy.create(
      title: title,
      description: description,
      url: vacancy_url,
      location: location,
      apply_link: apply_link
    )
  end
end
Database.connect_db