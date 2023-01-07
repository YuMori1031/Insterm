## プロジェクト名
### Insterm

## 概要
SSHを使用してリモートアクセスできるシンプルなSSHクライアントアプリです。

アプリにホスト名（IPアドレス等）、ユーザー名、パスワード、ポート番号を指定することで、SSHを使用してリモートログインができます。
ログイン後はターミナル画面を表示して、コマンド操作を行うことができます。

App Store: https://apps.apple.com/jp/app/insterm/id1662278977

## 環境構築
1. リポジトリをclone 

- *git clone https://github.com/YuMori1031/Insterm.git*

2. cocoapodsをインストール 

- *sudo gem install cocoapods*

3. cocoapodsをセットアップ

- *pod setup*

4. ライブラリのインストール

- *pod install*

##開発情報

| 項目 | バージョン |
| ---- | ---- |
| Xcode | 14.2 |
| Swift | 5.7.2 |
| iOS | 16.1以上 |
| CocoaPods | 1.11.3 |
| SwiftTerm | 2.0 |
| NMSSH | 2.3.1 |

## 使用ライブラリ
- *SwiftTerm*

ターミナルエミュレーションを行うためのライブラリです。

- *NMSSH*

SSH通信を行うためのライブラリです。

## バージョン管理
GitHubを使用。

## デザインパターン
MVCモデルを使用。

## 参考情報
SSHサーバーの環境がない場合は、下記のようなサービスを検討ください。
- *SDF Public Access UNIX System: https://sdf.lonestar.org/*

## デモ画面
![Simulator Screen Recording - iPhone SE (3rd generation) - 2023-01-05 at 07 59 59](https://user-images.githubusercontent.com/83987599/210666606-0e776a22-44a6-4ee3-a8fb-7ad9c005bbc0.gif)
