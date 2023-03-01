<!-- [![Test](https://github.com/Blackjacx/Engine/actions/workflows/test.yml/badge.svg)](https://github.com/Blackjacx/Engine/actions/workflows/test.yml) -->
[![Twitter Follow](https://img.shields.io/badge/Follow-%40Blackjacx-1DA1F2?logo=twitter)](https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fgithub.com%2Fblackjacx&screen_name=Blackjacxxx)
[![Version](https://shields.io/github/v/release/blackjacx/Engine?display_name=tag&include_prereleases&sort=semver)](https://github.com/Blackjacx/Engine/releases)
[![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FBlackjacx%2FEngine%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Blackjacx/Engine)
[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FBlackjacx%2FEngine%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Blackjacx/Engine)
[![Xcode 13+](https://img.shields.io/badge/Xcode-13%2B-blue.svg)](https://developer.apple.com/download/)
[![Codebeat](https://codebeat.co/badges/c1452aaa-260a-421a-8f1a-5b51ab3ad316)](https://codebeat.co/projects/github-com-blackjacx-engine-develop)
[![License](https://img.shields.io/github/license/blackjacx/engine.svg)](https://github.com/blackjacx/engine/blob/main/LICENSE)
[![Donate PayPal](https://img.shields.io/badge/Donate-PayPal-0079c1?logo=paypal)](https://www.paypal.me/STHEROLD)

# Engine

The engine that powers all my packages, tools and apps.

## Code Documentation

The [code documentation](https://swiftpackageindex.com/Blackjacx/Engine/develop/documentation/engine) is generated and hosted by [Swift Package Index](https://swiftpackageindex.com/) (powered by [DocC](https://developer.apple.com/documentation/docc))

## Release

To release this Swift package the following steps have to be taken:
- Create a new branch `release-x.y.z`
- Increment the version in https://github.com/Blackjacx/Engine/blob/develop/.spi.yml
- Run `bash <(curl -H -s https://raw.githubusercontent.com/Blackjacx/Scripts/master/frameworks/bootstrap.sh)` to update to the latest shared development files
- Run `bundle update` to update all Ruby gems
- Commit all changes, make a PR and merge it to develop
- Run `bundle exec fastlane release framework:"Engine" version:"x.y.z"` to release the new version
- Post the following on Twitter
```
Engine release x.y.z 🎉

▸ 🚀  Library package Engine (x.y.z) successfully published
▸ 📅  September 2nd
▸ 🌎  https://swiftpackageindex.com/Blackjacx/Engine
▸ 🌎  https://github.com/Blackjacx/Engine/releases/latest
▸ 👍  Tell your friends!

#SPM #Apple #Development #Support #Library #Package #Framework #Tools #Basics #Boilerplate #Code
```

## Contribution

- If you found a **bug**, please open an **issue**.
- If you have a **feature request**, please open an **issue**.
- If you want to **contribute**, please submit a **pull request**.

## Author

[Stefan Herold](mailto:stefan.herold@gmail.com) • 🐦 [@Blackjacxxx](https://twitter.com/Blackjacxxx)

## Contributors

Thanks to all of you who are part of this:

<a href="https://github.com/blackjacx/Engine/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=blackjacx/Engine" />
</a>

## License

Engine is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
