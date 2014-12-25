Gem::Specification.new do |s|
  s.name        = 'knox'
  s.version     = '0.1.0'
  s.date        = '2014-12-16'
  s.summary     = "Knox Payments api gem"
  s.description = "A simple to use ruby wrapper for Knox Payment API."
  s.authors     = ["James Rhodes"]
  s.email       = 'james@somehero.com'
  s.files       = ["lib/knox.rb", "lib/knox/config.rb", "lib/knox/banks.rb", "lib/knox/session.rb","lib/knox/account.rb","lib/knox/pay.rb"]
  s.homepage    =
    'https://github.com/jrhodes621/knox'
  s.license       = 'MIT'
  s.add_runtime_dependency "rest-client"
  s.add_runtime_dependency "json"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end
