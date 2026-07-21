<!-- [![Test](https://github.com/Blackjacx/Engine/actions/workflows/test.yml/badge.svg)](https://github.com/Blackjacx/Engine/actions/workflows/test.yml) -->

[![X Follow](https://img.shields.io/badge/Follow-%40Blackjacx-1DA1F2?logo=twitter)](https://twitter.com/intent/follow?original_referer=https%3A%2F%2Fgithub.com%2Fblackjacx&screen_name=Blackjacxxx)
[![Version](https://shields.io/github/v/release/blackjacx/Engine?display_name=tag&include_prereleases&sort=semver)](https://github.com/Blackjacx/Engine/releases)
[![Swift Package Manager Compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FBlackjacx%2FEngine%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Blackjacx/Engine)
[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FBlackjacx%2FEngine%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Blackjacx/Engine)
[![Xcode 26+](https://img.shields.io/badge/Xcode-26%2B-blue.svg)](https://developer.apple.com/download/)
[![License](https://img.shields.io/github/license/blackjacx/engine.svg)](https://github.com/blackjacx/engine/blob/main/LICENSE)
[![Donate PayPal](https://img.shields.io/badge/Donate-PayPal-0079c1?logo=paypal)](https://www.paypal.me/STHEROLD)

# Engine

The engine that powers all my packages, tools and apps.

## Code Documentation

The [code documentation](https://swiftpackageindex.com/Blackjacx/Engine/develop/documentation/engine) is generated and hosted by [Swift Package Index](https://swiftpackageindex.com/) (powered by [DocC](https://developer.apple.com/documentation/docc))

## Release

To release this Swift package the following steps have to be taken:

- Make sure all features / PRs are merged to `develop`
- Checkout develop and pull:
  ```shell
  git checkout develop && git pull
  ```
- Update to the latest shared development files:
  ```shell
  bash <(curl -H -s https://raw.githubusercontent.com/Blackjacx/Scripts/main/frameworks/bootstrap.sh)
  ```
- Run `bundle update` to update all Ruby gems
- Run `swift package update` to update all SPM dependencies
- Commit all changes on `develop` using:
  ```
  git commit -am "Release version 'x.y.z'"
  ```
- Release the new version:
  ```shell
  bundle exec fastlane release framework:"Engine" version:"x.y.z"
  ```
- Post the following on Twitter:

  ```
  Engine release x.y.z 🎉

  ▸ 🚀  Library package Engine successfully published
  ▸ 📅  Sep 15th
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

[Stefan Herold](mailto:stefan.herold@gmail.com) • [X](https://twitter.com/Blackjacxxx) • [Bluesky](https://bsky.app/profile/blackjacx.bsky.social) • [Mastodon](https://mastodon.social/@blackjacx)

## Contributors

Thanks to all of you who are part of this:

<a href="https://github.com/blackjacx/Engine/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=blackjacx/Engine" />
</a>

## License

Engine is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
