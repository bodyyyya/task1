Gem::Specification.new do |s|
  s.name          = "vacancy_pars"
  s.version       = "0.1.5"
  s.summary       = "A Ruby gem for parsing vacancies from OpenAI."
  s.description   = "Ruby gem for scraping vacancies from a OpenAI website and save it to database."
  s.authors       = ["Bogdan Vintoniuk"]
  s.email         = "vbogdanua177@gmail.com"
  s.files         = Dir["app/*.rb"]
  s.require_paths = ['app']
  s.add_runtime_dependency "nokogiri"
  s.add_runtime_dependency "httparty"
  s.add_runtime_dependency "activerecord"
  s.add_runtime_dependency "dotenv"
end