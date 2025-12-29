# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

target 'SpotifyForTeens' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Spotify iOS SDK
  # Note: As of 2025, check the official Spotify iOS SDK documentation for the latest pod name
  # The SDK may have changed - verify at https://developer.spotify.com/documentation/ios
  
  # If using official Spotify iOS SDK (verify current availability):
  # pod 'SpotifyiOS', '~> 1.0'
  
  # Alternative: Manual SDK integration may be required
  # Download from: https://github.com/spotify/ios-sdk
  
  # Networking
  pod 'Alamofire', '~> 5.8'
  
  # Image loading and caching
  pod 'Kingfisher', '~> 7.10'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
  end
end
