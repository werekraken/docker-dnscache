require 'docker'
require 'rspec'
require 'serverspec'

def image
  RSpec.configuration.image
end

RSpec.configure do |config|
  # Define persistant image setting
  config.add_setting :image, :default => nil

  config.before(:suite) do
    RSpec.configuration.image = Docker::Image.build_from_dir('.', { 'pull' => 1 })
  end
end
