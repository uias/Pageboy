platform :ios, '9.0'

target 'Pageboy-Example' do
  workspace 'Pageboy'
  project './Example/Pageboy-Example.xcodeproj'

  use_frameworks!

  pod 'BulletinBoard', '~> 2.0'
  pod 'SnapKit', '~> 4.0'

end

post_install do |installer|
  
  # convert incompatible pods back to Swift 4.1
  myTargets = ['BulletinBoard', 'SnapKit']  
  installer.pods_project.targets.each do |target|
    if myTargets.include? target.name
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4.1'
      end
    end
  end
end