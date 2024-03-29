$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "omni_account/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "omni_account"
  s.version     = OmniAccount::VERSION
  s.authors     = ["Andersen Fan"]
  s.email       = ["as181920@gmail.com"]
  s.homepage    = ""
  s.summary     = "Common accounting for rails"
  s.description = "Basic Bookkeeping for accounts with balance equation, without overkill abstractions"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 6.1"

  s.add_development_dependency "pg"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "minitest-reporters"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-minitest"
end
