platform :ios, '9.0'

def shared_pods

  pod 'SwiftLint'
  
end

target 'Pageboy iOS' do
  workspace 'Pageboy'
  project './Sources/Pageboy.xcodeproj'

  use_frameworks!
  shared_pods

  target 'PageboyTests' do
    inherit! :search_paths
    shared_pods

  end
end
