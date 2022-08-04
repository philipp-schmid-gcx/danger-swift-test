desc "Run unit tests"
lane :test do
  # Build for testing
  scan(
    project: "DangerTests.xcodeproj",
    scheme: ENV["SCHEME"],
    configuration: "Debug",
    device: "iPhone 12",
    buildlog_path: "../logs",
    build_for_testing: true,
  )

  # Run tests
  scan(
    project: "DangerTests.xcodeproj",
    scheme: ENV["SCHEME"],
    configuration: "Debug",
    device: "iPhone 12",
    code_coverage: true,
    disable_concurrent_testing: true,
    fail_build: true,
    output_types: "junit",
    buildlog_path: "../logs",
    include_simulator_logs: false,
    skip_build: true,
    test_without_building: true,
  )

  slather(
    scheme: ENV["SCHEME"],
    proj: "DangerTests.xcodeproj",
    json: true,
    output_directory: "fastlane"
  )

end
