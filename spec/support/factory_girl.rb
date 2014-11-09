RSpec.configure do |config|
  # additional factory_girl configuration

# RSpec
# spec/support/factory_girl.rb
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end
end
