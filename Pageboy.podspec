Pod::Spec.new do |s|

  s.name         = "Pageboy"
  s.platform     = :ios, "9.0"
  s.requires_arc = true

  s.version      = "0.4.0"
  s.summary      = "UIPageViewController done properly."
  s.description  = <<-DESC
  					TODO
                   DESC

  s.homepage     = "https://github.com/MerrickSapsford/Pageboy"
  s.license      = "MIT"
  s.author       = { "Merrick Sapsford" => "merrick@sapsford.tech" }
  s.social_media_url   = "http://twitter.com/MerrickSapsford"

  s.source       = { :git => "https://github.com/MerrickSapsford/Pageboy.git", :tag => s.version.to_s }
  s.source_files  = "Sources/Pageboy/**/*.{h,m,swift}"

end
