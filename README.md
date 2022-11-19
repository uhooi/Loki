# Loki

[![Release](https://img.shields.io/github/v/release/uhooi/Loki)](https://github.com/uhooi/Loki/releases/latest)
[![Twitter](https://img.shields.io/twitter/follow/the_uhooi?style=social)](https://twitter.com/the_uhooi)

Loki（ロキ）は、サ活の記録に特化したアプリです。

<a href="https://apps.apple.com/jp/app/ロキ/id6444580805?itsct=apps_box_badge&amp;itscg=30200" style="display: inline-block; overflow: hidden; border-radius: 13px; width: 250px; height: 83px;"><img src="https://tools.applemediaservices.com/api/badges/download-on-the-app-store/black/ja-jp?size=250x83&amp;releaseDate=1668816000&h=208fad97f748bc6c581dd384ccf2b393" alt="Download on the App Store" style="border-radius: 13px; width: 250px; height: 83px;"></a>

## 目次

- [スクリーンショット](#スクリーンショット)
- [開発](#開発)
- [貢献](#貢献)

## スクリーンショット

TBD

## 開発

誰でもこのプロジェクトを開発できます。

### 必要条件

- macOS 12.5+
- Xcode 14.1 (Swift 5.7.1)
- Make

### 構成

- UIの実装: SwiftUI
- アーキテクチャ: MVVM
- ブランチモデル: GitHub flow

### セットアップ

1. このプロジェクトをクローンします。  
    ```shell
    $ git clone https://github.com/uhooi/Loki.git
    $ cd Loki
    ```

2. Swiftプロジェクトの高速ビルドを有効にします。（任意）  
    ```shell
    $ defaults write com.apple.dt.XCBuild EnableSwiftBuildSystemIntegration 1
    ```

3. `make setup` を実行します。  
セットアップが完了すると、自動的にXcodeでワークスペースが開きます。

## 貢献

貢献をお待ちしています :relaxed:

- [新しいイシュー](https://github.com/uhooi/Loki/issues/new)
- [新しいプルリクエスト](https://github.com/uhooi/Loki/compare)
