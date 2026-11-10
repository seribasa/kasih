require 'xcodeproj'

abort 'This helper is restricted to GitHub Actions' unless ENV['GITHUB_ACTIONS'] == 'true'
settings = {
  'DEVELOPMENT_TEAM' => ENV.fetch('IOS_TEAM_ID'),
  'PRODUCT_BUNDLE_IDENTIFIER' => ENV.fetch('IOS_BUNDLE_ID'),
  'CODE_SIGN_STYLE' => 'Manual',
  'CODE_SIGN_IDENTITY' => ENV.fetch('IOS_SIGNING_IDENTITY'),
  'PROVISIONING_PROFILE_SPECIFIER' => ENV.fetch('IOS_PROFILE_UUID'),
  'OTHER_CODE_SIGN_FLAGS' => "$(inherited) --keychain #{ENV.fetch('RUNNER_TEMP')}/kasih-ios-signing/build.keychain-db"
}
project = Xcodeproj::Project.open('ios/Runner.xcodeproj')
runner = project.targets.find { |target| target.name == 'Runner' }
abort 'Runner target missing' unless runner
# Set signing only on the application, not on CocoaPods frameworks/resources.
runner.build_configurations.each { |config| config.build_settings.merge!(settings) }
project.save
