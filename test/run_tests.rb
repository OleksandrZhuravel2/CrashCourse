require 'minitest/autorun'
require 'minitest/reporters'


report_dir = 'test/html_reports'
Dir.mkdir(report_dir) unless Dir.exist?(report_dir)


Minitest::Reporters.use! Minitest::Reporters::HtmlReporter.new(
  filename: "#{report_dir}/test_results.html",
  title: "Minitest Results",
  verbose: false,
  mode: :terse
)


Dir.glob('test/src/*_test.rb').each { |file| require_relative "../#{file}" }
