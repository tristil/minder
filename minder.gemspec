lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minder/version'

Gem::Specification.new do |spec|
  spec.name          = "minder"
  spec.version       = Minder::VERSION
  spec.authors       = ["Joseph Method"]
  spec.email         = ["tristil@gmail.com"]
  spec.description   = %q{Productivity tool borrowing a little from everything.}
  spec.summary       = %q{Combines a Pomodoro Technique runner with GTD-style task backlogs and Day One-style prompts."}
  spec.homepage      = "http://github.com/tristil/minder"

  spec.files         = `git ls-files`.split($/).reject { |file| file =~ /website/ }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'

  spec.add_runtime_dependency 'curses', '~> 1.0.0', '>= 1.0.1'
  spec.add_runtime_dependency 'virtus', '~> 1.0.0', '>= 1.0.5'
  spec.add_runtime_dependency 'rom', '~> 0.9.1', '>= 0.9.1'
  spec.add_runtime_dependency 'rom-sql', '~> 0.6.0', '>= 0.6'
  spec.add_runtime_dependency 'sqlite3', '~> 1.3.10', '>= 1.3.10'
  spec.add_runtime_dependency 'activesupport', '~> 4.2.4', '>= 4.2.4'
  spec.add_runtime_dependency 'gemoji', '~> 2.1.0', '>= 2.1.0'

  spec.add_development_dependency "bundler", '~> 1'
  spec.add_development_dependency "rake", "~> 10.4.2", '>= 10.4.2'
  spec.add_development_dependency "rspec", '~> 3.2.0', '>= 3.2.0'
  spec.add_development_dependency "timecop", '~> 0.7.3', '>= 0.7.3'
  spec.add_development_dependency "pry", '~> 0.10.1', '>= 0.10.1'
  spec.add_development_dependency "pry-byebug", '~> 3.1.0', '>= 3.1.0'
  spec.add_development_dependency 'pry-stack_explorer', '~> 0.4.9.2', '>= 0.4.9.2'

  spec.licenses = ['MIT']
end

