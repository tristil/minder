namespace :gem do
  desc 'Bump patch version of gem'
  task :bump do
    file_name = File.dirname(__FILE__) + "/lib/minder/version.rb"
    major, minor, patch = nil, nil, nil

    text = File.read(file_name)
    regexp = /VERSION = '(\d+)\.(\d+)\.(\d+)'/
    md = text.match(regexp)
    major, minor, patch = md[1], md[2], md[3]
    patch = patch.to_i + 1

    new_version = "#{major}.#{minor}.#{patch}"
    new_text = text.gsub(regexp, "VERSION = '#{new_version}'")
    File.write(file_name, new_text)
    `git commit -am 'Bump gem version to #{new_version}'`
  end

  task :release do
    result = `gem build minder.gemspec`
    file = result.match(/File: (.*)\Z/)[1]
    command = "gem push #{file}"
    puts "Run #{command}? (y/n)"
    if STDIN.getc == 'y'
      system(command)
    else
      puts "Nothing done."
    end
  end
end

