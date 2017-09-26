Pod::Spec.new do |s|
  s.name             = "ZomojiKeyboard"
  s.version          = "1.0"
  s.summary          = "Custom input view for iOS Keyboards with Zomojis"
  s.license          = { :type => "Apache", :text=> <<-LICENSE

  Copyright (c) 2017, ZOHO CORPORATION
  All rights reserved.

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.

  LICENSE
  }
  s.homepage         = "https://github.com/zoho/zomoji-iOS-keyboard"
  s.author           = { "Vijay Sankar S" => "vijaysankar.s@zohocorp.com" }
  s.source           = { :git => "https://github.com/zoho/zomoji-iOS-keyboard.git", :tag => s.version }
  s.social_media_url = "https://zomojis.com/"
  s.platform         = :ios, '8.0'
  s.source_files     = ["Keyboard/*.swift","Utils/*.swift"]
  s.resources        = ["Resources/ZomojiAssets.xcassets"]
  s.module_name      = 'ZomojiKeyboard'
  s.dependency 'YYImage', '~> 1.0.4'
end
