require 'signaling'
require 'pathname'
require 'webmock/rspec'
require 'pry'
require 'rack'
require 'addressable/uri'

project_root = Pathname.new(__FILE__).join('../..').expand_path

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[project_root.join("spec/support/**/*.rb").to_s].each { |f| require f }

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
