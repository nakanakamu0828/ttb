require "bundler/setup"
require "tinify"
Tinify.key = ENV["TINIFY_API_KEY"]

return if ARGV.empty?

filepath = ARGV[0]
return unless File.exists?(filepath)

source = Tinify.from_file(filepath)
source.to_file(filepath)