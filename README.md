# Zomoji Keyboard

A custom view for your `UITextFields` and `UITextViews` that has all the Zomojis that you can get!

## Installation

### CocoaPods

To add Zomoji Keyboard to your project, include the following in your `PodFile`:

```ruby
pod 'ZomojiKeyboard'
```

> Users who have objective c code bases will have to add the following code to their `PodFile` as well. 

```ruby
post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'ZomojiKeyboard'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '4.0'
            end
        end
    end
end
```
> XCode 9 doesn't set the swift version correctly for `Swift` libraries within `Objective C` projects. If you find a better solution, feel free to fork and update.

### Manual

If you prefer not to use CocoaPods, copy all the files within the `Keyboard` and `Utils` folders in addition to `ZomojiAssets.xcassets`.

## Usage

1. Create a `KeyboardController` object and set a delegate ( that conforms to `ZKeyboardDelegate` ) if you want callbacks.
2. Use the `keyboard(withParams:)` function of the `KeyboardController` to get the custom input view and assign it as the `inputView` of your `UITextField` or `UITextView`
3. When any Zomoji (be it live or static) is tapped, a dictionary is sent along with the callback. This dictionary will contain
     1. The data of the chosen image
     2. A boolean to describe if the image is animatable or not
     3. The number of frames an animatable image would contain
     4. The starting frame of the animation
     5. And, the name of the image tapped
4. You can use this information to present the Zomojis to your users

---

Any suggestions for improvements are welcome
