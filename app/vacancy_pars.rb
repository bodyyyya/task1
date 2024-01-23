require 'active_record'
require 'nokogiri'
require 'httparty'

# Підключення до бази даних PostgreSQL
ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  host: 'localhost',
  database: 'parsing',
  user: 'bodya',
  password: 'bodya1'
)

# Модель для таблиці вакансій
class Vacancy < ActiveRecord::Base
end

# Створення таблиці, якщо вона ще не існує
unless ActiveRecord::Base.connection.table_exists?(:vacancies)
  ActiveRecord::Base.connection.create_table :vacancies do |t|
    t.string :title
    t.text :description
    t.string :url
    t.string :location

    t.timestamps
  end
end

# Функція для збору вакансій
def scrape_vacancies
  base_url = 'https://openai.com/careers/search'
  response = HTTParty.get(base_url)

  if response.body.nil? || response.body.empty?
    puts 'Error: Empty response body'
    exit
  end

  doc = Nokogiri::HTML(response.body)

  # Отримати всі посилання на вакансії
  vacancy_links = doc.css('.job-listing-title a').map { |link| link['href'] }

  # Зберегти інформацію про кожну вакансію
  vacancy_links.each do |link|
    vacancy_url = "https://openai.com#{link}"
    vacancy_response = HTTParty.get(vacancy_url)

    if vacancy_response.body.nil? || vacancy_response.body.empty?
      puts "Error: Empty response body for vacancy #{vacancy_url}"
      next
    end

    vacancy_doc = Nokogiri::HTML(vacancy_response.body)

    title = vacancy_doc.css('.f-display-2').text.strip
    description = vacancy_doc.css('.ui-description').text.strip
    location = vacancy_doc.css('.f-subhead-1').text.strip
    apply_link = vacancy_doc.css('.ui-link[aria-label="Apply now"]').first['href']

    # Збереження в базу даних
    Vacancy.create(
      title: title,
      description: description,
      url: vacancy_url,
      location: location
    )

    puts "Vacancy '#{title}' saved to the database."
  end
end

# Виклик функції для збору вакансій
#scrape_vacancies

Vacancy.all.each do |a|
  puts a.description
end
puts "Total Vacancies: #{Vacancy.count}"

