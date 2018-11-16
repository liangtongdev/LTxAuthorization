Pod::Spec.new do |s|
    s.name         = "LTxAuthorizationSippr"
    s.version      = "0.0.4"
    s.summary      = "授权定制功能. "
    s.license      = "MIT"
    s.author             = { "liangtong" => "liangtongdev@163.com" }
    
    s.homepage     = "https://github.com/liangtongdev/LTxAuthorization"
    s.platform     = :ios, "9.0"
    s.ios.deployment_target = "9.0"
    s.source       = { :git => "https://github.com/liangtongdev/LTxAuthorization.git", :tag => "#{s.version}", :submodules => true }
    
    s.dependency "LTxAuthorizationUI"
    s.dependency "LTxEepMSippr"
    
    s.frameworks = "Foundation", "UIKit"
    
    s.source_files  =  "LTxAuthorizationSippr/*.{h,m}"
    s.public_header_files = "LTxAuthorizationSippr/*.h"
    
    
end
