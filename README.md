# Vacancy Parser

Vacancy Parser is a Ruby gem designed to scrape job vacancies from the OpenAI website and save them to a PostgreSQL database.

## Features

- Scrapes vacancies from OpenAI.
- Saves job details such as title, description, location, and application link.
- Utilizes Nokogiri for HTML parsing and HTTParty for making HTTP requests.
- Stores data in a PostgreSQL database using ActiveRecord.

## Getting Started

### Prerequisites

Make sure you have the following installed:

- Ruby

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/bodyyyya/vacancy-parser.git

# How to use it like code
### Change into the project directory:
  ```bash
cd vacancy-parser
```
### Install dependencies:
```
bundle install
```
### Set up the database configuration:

Create a .env file with your database credentials:
```bash
OPENAI_CAREERS_URL=https://openai.com/careers/search
DATABASE=your_database_name
DATABASE_USERNAME=your_database_username
DATABASE_PASSWORD=your_database_password
```
### Run code in terminal
```bash
ruby bin/app.rb
```
# Vacancy Parser Tests

This repository contains test cases for the Vacancy Parser Ruby gem.

## Running Tests

### Make sure you have the necessary dependencies installed:

```bash
bundle install
```
### Edit the data in spec/scraper_spec.rb to the data you want to test
Example with a Account Associate vacancy test
```bash
let(:saved_link) { 'https://openai.com/careers/account-associate' }

vacancy = Vacancy.find_by(title: 'Account Associate')

expect(vacancy.title).to eq('Account Associate')
expect(vacancy.location).to eq('San Francisco, California, United States — Go To Market')
expect(vacancy.url).to eq(saved_link)
```
You can change these fields to test anything in the database

### Run rspec test:
```bash
rspec spec/scraper_test.rb
```

# Vacancy Parser Gem
- Gem version: 0.1.7
- Summary: A Ruby gem for parsing vacancies from OpenAI.
- Description: Ruby gem for scraping vacancies from a OpenAI website and save it to database.
### Make sure you have created an .env file with your database credentials:
```bash
OPENAI_CAREERS_URL=https://openai.com/careers/search
DATABASE=your_database_name
DATABASE_USERNAME=your_database_username
DATABASE_PASSWORD=your_database_password
```
### Make sure you have a cloned vacancy_pars file:
It's look like this:
```bash
vacancy_pars-0.1.7.gem
```

### Gem install command
```bash
gem install vacancy_pars-0.1.7.gem
```

### Start irb console:
```bash
irb
```
### Call the gem in the irb console
```bash
irb(main):001:0> require "vacancy_pars"
=> true
irb(main):003:0> Database.connect_db
irb(main):003:0> Scraper.call