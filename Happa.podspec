#
# Be sure to run `pod lib lint Happa.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "Happa"
  s.version          = "0.0.1"
  s.summary          = "Happa is a library to control when to execute function with closed scope context."

  s.description      = <<-DESC
Happa is a library to control when to execute function with closed scope context.

It reduces complexy to manage many flags or counters to control flow.
  DESC

  s.homepage         = "https://github.com/muniere/Happa"
  s.license          = 'MIT'
  s.author           = { "Hiromune Ito" => "muniere.fujiwara@gmail.com" }
  s.source           = { :git => "https://github.com/muniere/Happa.git", :tag => s.version.to_s }

  s.platform         = :ios, '8.0'
  s.requires_arc     = true

  s.source_files     = 'Source/**/*'
end

# vim: ft=ruby
