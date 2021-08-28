# Copyright (c) 2021 Automatic Magic LLC
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
########################################################################################################################

require 'fileutils'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new

task :update_measure do
  puts "Updating Measures"

  Dir.glob('./lib/measures/*').each do |p|
    FileUtils.cp('LICENSE', File.join(p, 'LICENSE.md'))
  end

  require 'openstudio'
  require 'open3'

  cli = OpenStudio.getOpenStudioCLI
  command = "#{cli} measure -t './lib/measures'"
  puts command
  out, err, ps = Open3.capture3({"BUNDLE_GEMFILE"=>nil}, command)
  raise "Failed to update measures\n\n#{out}\n\n#{err}" unless ps.success?
end

task :spec => [:update_measure]

task default: :spec
