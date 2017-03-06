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
    Docker::Image.create('fromImage' => 'werekraken/dnscache', 'tag' => 'latest')
    RSpec.configuration.image = Docker::Image.build_from_dir('.', { 'cachefrom' => [ 'werekraken/dnscache:latest' ].to_json, 'pull' => 1 }) do |v|
      if ENV['DOCKER_BUILD_VERBOSE'] == 'yes'
        if (log = JSON.parse(v)) && log.key?("stream")
          $stdout.puts log["stream"]
        end
      end
    end
  end
end
