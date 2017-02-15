Pod::Spec.new do |s|

  s.name         = "Pageboy"
  s.version      = "0.0.1"
  s.summary      = "TODO"

  s.description  = <<-DESC
                        TODO
                     DESC

  s.homepage     = "https://github.com/MerrickSapsford/Pageboy"
  #s.screenshots  = "https://raw.githubusercontent.com/MerrickSapsford/MSSTabbedPageViewController/develop/Resource/MSSTabbedPageViewController.gif"
  s.license      = "MIT"
  s.author       = { "Merrick Sapsford" => "merrick@sapsford.tech" }
  s.social_media_url   = "http://twitter.com/MerrickSapsford"

  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/MerrickSapsford/Pageboy.git", :tag => s.version.to_s }
  s.requires_arc = true
  s.source_files  = "Pageboy/**/*.{h,m,swift}"
  s.resources = ['Source/**/*.{xib}']
  s.frameworks = 'UIKit'

end
