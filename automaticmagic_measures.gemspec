lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'automaticmagic_measures/version'

Gem::Specification.new do |spec|
  spec.name          = 'AutomaticMagicMeasures'
  spec.version       = AutomaticMagicMeasures::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Daniel Macumber']
  spec.email         = ['dan@automaticmagic.com']

  spec.homepage      = 'https://github.com/automaticmagic/automaticmagic-measures'
  spec.summary       = ''
  spec.description   = ''
  spec.metadata = {
      'bug_tracker_uri' => 'https://github.com/automaticmagic/automaticmagic-measures/issues',
      'source_code_uri' => "https://github.com/automaticmagic/automaticmagic-measures/tree/v#{spec.version}"
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  if /^2.2/.match(RUBY_VERSION)
    spec.required_ruby_version = '~> 2.2.0'

    spec.add_development_dependency 'bundler', '~> 1.17.1'
    spec.add_development_dependency 'rake', '~> 12.3'
    spec.add_development_dependency 'rspec', '~> 3.7.0'
    spec.add_development_dependency 'rubocop', '~> 0.54.0'
  else
    spec.required_ruby_version = '>= 2.5.0'

    spec.add_development_dependency 'bundler', '~> 2.1'
    spec.add_development_dependency 'rake', '~> 13.0'
    spec.add_development_dependency 'rspec', '~> 3.9'
    spec.add_development_dependency 'rubocop', '> 0.54.0'
  end


end
