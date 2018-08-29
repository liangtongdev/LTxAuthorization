Pod::Spec.new do |s|
    s.name         = "LTxAuthorizationUI"
    s.version      = "0.0.1"
    s.summary      = "通用用户授权页面. "
    s.license      = "MIT"
    s.author             = { "liangtong" => "liangtongdev@163.com" }
    
    s.homepage     = "https://github.com/liangtongdev/LTxAuthorization"
    s.platform     = :ios, "9.0"
    s.ios.deployment_target = "9.0"
    s.source       = { :git => "https://github.com/liangtongdev/LTxAuthorization.git", :tag => "#{s.version}", :submodules => true }
    
    s.dependency "LTxCore"
    
    s.frameworks = "Foundation", "UIKit"
    
    s.source_files  =  "LTxAuthorizationUI/*.{h,m}"
    s.public_header_files = "LTxAuthorizationUI/*.h"
    
end
