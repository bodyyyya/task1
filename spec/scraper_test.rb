require 'rspec'
require 'webmock/rspec'
require_relative '../app/vacancy_pars.rb'  
require_relative '../app/db'


RSpec.describe Scraper do
  describe '#call' do
    let(:saved_link) { 'https://openai.com/careers/account-associate' }

    before do
      stub_request(:get, ENV['OPENAI_CAREERS_URL'])
        .to_return(body: File.read('spec/vacancies_page.html'))
      
      individual_vacancy_link = "#{ENV['OPENAI_CAREERS_URL']}/job1"
    
      stub_request(:get, individual_vacancy_link)
        .to_return(body: File.read('spec/vacancies_page.html'))
    end

    it 'scrapes and saves vacancies to the database' do
      Database.connect_db
      Vacancy.all
      vacancy = Vacancy.first
      # Replace with the actual assertions based on your HTML content
      expect(vacancy.title).to eq('Account Associate')
      expect(vacancy.location).to eq('San Francisco, California, United States — Go To Market')
      expect(vacancy.url).to eq(saved_link)
    end
  end
end