require 'docker'
require 'rspec'
require 'serverspec'
require 'yaml'

def image
  RSpec.configuration.image
end

RSpec.configure do |config|
  # Define persistant image setting
  config.add_setting :image, :default => nil

  config.before(:suite) do
    cachefrom = nil
    unless ENV['DOCKER_BUILD_CACHE_FROM'] == 'no'
      metadata = YAML.load_file('metadata.yaml')
      Docker::Image.create('fromImage' => metadata['docker_repo'], 'tag' => 'latest')
      cachefrom = [ "#{metadata['docker_repo']}:latest" ].to_json
    end
    RSpec.configuration.image = Docker::Image.build_from_dir('.', { 'cachefrom' => cachefrom, 'pull' => 1 }) do |v|
      if ENV['DOCKER_BUILD_VERBOSE'] == 'yes'
        if (log = JSON.parse(v)) && log.key?("stream")
          $stdout.puts log["stream"]
        end
      end
    end
  end
end
