Pod::Spec.new do |s|
  s.name         = "AKLookups"
  s.version      = "0.9.0"
  s.summary      = "drop-down list for selecting items"
  s.description  = "AKLookups class implements a drop-down list for selecting particular value of set."
  s.homepage     = "https://github.com/purrrminator/AKLookups"
  s.screenshots  = "http://cdn.makeagif.com/media/5-17-2014/GlTvIy.gif"
  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "Andrey Kadochnikov" => "kaskaaddnb@gmail.com" }
  s.social_media_url   = "http://twitter.com/purrrminator"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/purrrminator/AKLookups.git", :tag => s.version.to_s }
  s.source_files  = "Classes", "Classes/*.{h,m}"
  s.public_header_files = "Classes/*.h"
  s.resources = "Resources/*.png"
  s.requires_arc = true
end
