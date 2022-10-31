# Totonoi-iOS

[![Release](https://img.shields.io/github/v/release/uhooi/Totonoi-iOS)](https://github.com/uhooi/Totonoi-iOS/releases/latest)

Totonoi（整い）は、サ活の記録に特化したアプリです。

## 目次

- [開発](#開発)
- [貢献](#貢献)

## 開発

誰でもこのプロジェクトを開発できます。

### 必要条件

- macOS 12.5+
- Xcode 14.0.1 (Swift 5.7)
- Make

### 構成

- UIの実装: SwiftUI
- アーキテクチャ: MVVM
- ブランチモデル: GitHub flow

### セットアップ

1. このプロジェクトをクローンします。  
    ```shell
    $ git clone https://github.com/uhooi/Totonoi-iOS.git
    $ cd Totonoi-iOS
    ```

2. Swiftプロジェクトの高速ビルドを有効にします。（任意）  
    ```shell
    $ defaults write com.apple.dt.XCBuild EnableSwiftBuildSystemIntegration 1
    ```

3. `make setup` を実行します。  
セットアップが完了すると、自動的にXcodeでワークスペースが開きます。

## 貢献

貢献をお待ちしています :relaxed:

- [新しいイシュー](https://github.com/uhooi/Totonoi-iOS/issues/new)
- [新しいプルリクエスト](https://github.com/uhooi/Totonoi-iOS/compare)
