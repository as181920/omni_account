# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"

Minitest.backtrace_filter = Minitest::BacktraceFilter.new

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [File.expand_path("fixtures", __dir__)]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures/files", __dir__)
  ActiveStorage::FixtureSet.file_fixture_path = ActiveSupport::TestCase.file_fixture_path
  ActiveSupport::TestCase.fixtures :all
  ActiveSupport::TestCase.parallelize workers: :number_of_processors
end

require "minitest/reporters"
Minitest::Reporters.use!

require "factory_bot_rails"
FactoryBot.definition_file_paths = [
  File.expand_path("../factories", __FILE__),
  File.expand_path("../factories/**/*", __FILE__)
]
FactoryBot.find_definitions

require "database_cleaner"
DatabaseCleaner.strategy = :truncation # :transaction

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  self.use_transactional_tests = false

  setup do
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
end
