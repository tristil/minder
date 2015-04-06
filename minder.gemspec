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

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "pry"
end

