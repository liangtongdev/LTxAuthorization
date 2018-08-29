Pod::Spec.new do |s|
    s.name         = "LTxAuthorizationSippr"
    s.version      = "0.0.1"
    s.summary      = "通用用户登录页面（功能）. "
    s.license      = "MIT"
    s.author             = { "liangtong" => "liangtongdev@163.com" }
    
    s.homepage     = "https://github.com/liangtongdev/LTxAuthorization"
    s.platform     = :ios, "9.0"
    s.ios.deployment_target = "9.0"
    s.source       = { :git => "https://github.com/liangtongdev/LTxAuthorization.git", :tag => "#{s.version}", :submodules => true }
    
    s.dependency "LTxAuthorizationUI"
    
    
    s.frameworks = "Foundation", "UIKit"
    
    s.source_files  =  "LTxAuthorizationSippr/*.{h,m}"
    s.public_header_files = "LTxAuthorizationSippr/*.h"
    
    
end
