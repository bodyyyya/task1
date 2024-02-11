# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'
require_relative '../app/vacancy_pars'
require_relative '../app/db'

RSpec.describe Scraper do
  describe '#scrape' do
    let(:base_url) { 'https://openai.com/careers/search' }
    let(:invalid_html) { '<html><head></head><body><p>Not a valid job listing page</p></body></html>' }
    let(:saved_link) { 'https://openai.com/careers/analytics-data-engineer-applied-engineering' }
    let(:scraper) { Scraper.new }

    before do
      stub_request(:get, ENV['OPENAI_CAREERS_URL'])
        .to_return(body: File.read('spec/vacancies_page.html'))

      individual_vacancy_link = "#{ENV['OPENAI_CAREERS_URL']}/job1"

      stub_request(:get, individual_vacancy_link)
        .to_return(body: File.read('spec/vacancies_page.html'))
    end

    describe '#call' do
      context 'when the request is successful' do
        before { scraper.call }

        it 'parses job data correctly' do
          Database.connect_db
          # Replace with the actual assertions based on your HTML content
          vacancy = Vacancy.find_by(title: 'Analytics Data Engineer, Applied Engineering')
          expect(vacancy.title).to eq('Analytics Data Engineer, Applied Engineering')
          expect(vacancy.location).to eq('San Francisco, California, United States — Applied AI Engineering')
          expect(vacancy.url).to eq(saved_link)
        end
      end

      context 'when the request fails' do
        before do
          stub_request(:get, base_url).to_return(status: 500)
          stub_request(:get, saved_link).to_return(status: 500)
        end

        it 'handles the error gracefully' do
          expect { scraper.call }.not_to raise_error
        end
      end
    end
    context 'when the HTML structure is unexpected' do
      before do
        stub_request(:get, base_url).to_return(status: 200, body: invalid_html)
      end

      it 'handles the parsing error gracefully' do
        expect { scraper.call }.not_to raise_error
      end
    end
  end
end
