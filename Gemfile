source "https://rubygems.org"

gem "fastlane"
gem "danger"
gem "danger-junit_results"
gem "danger-xcov"
gem "danger-swiftlint"
gem "jazzy"
gem "danger-swiftformat", '0.7.0'
gem "slather"
plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
