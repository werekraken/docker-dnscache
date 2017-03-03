require 'rubygems'
require 'bundler/setup'

require 'docker'
require 'fileutils'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RuboCop::RakeTask.new

RSpec::Core::RakeTask.new(:spec)

desc 'Run dockerfile_lint'
task :lint do
  proj_root = File.dirname(__FILE__)
  FileList['**/Dockerfile'].exclude(/^vendor/).each do |dockerfile|
    puts "---> lint:#{dockerfile}"
    image = Docker::Image.create('fromImage' => 'projectatomic/dockerfile-lint', 'tag' => 'latest')
    container = Docker::Container.create({
      :Cmd        => [ 'dockerfile_lint', '-r', '.dockerfile_lint.yml', '-f', dockerfile ],
      :Image      => image.id,
      :HostConfig => {
        :Binds      => ["#{proj_root}:/root"],
        :Privileged => true,
      },
      :Tty        => true,
      :Volumes    => { '/root' => {} },
    })

    container.start

    status_code = container.wait['StatusCode']
    puts container.logs(stdout: true)

    container.remove

    if status_code.nonzero?
      exit status_code
    end
  end
end

desc 'Run lint, rubocop, and spec'
task :test => [
  :lint,
  :rubocop,
  :spec,
]
