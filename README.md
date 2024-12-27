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

2. Swift Package Managerで依存関係を解決 

- プロジェクトをXcodeで開き、必要なパッケージが自動で解決されることを確認してください。

##開発情報

| 項目 | バージョン |
| ---- | ---- |
| Xcode | 16.2 |
| Swift | 6.0.3 |
| iOS | 17.0以上 |

## 使用ライブラリ
- *LicenseList*

アプリで利用しているライブラリのライセンス一覧を生成するライブラリです。

- *SwiftTerm*

ターミナルエミュレーションを行うためのライブラリです。

- *NMSSH*

SSH通信を行うためのライブラリです。

- *Shake*

アプリからバグ情報やフィードバック送信を行うためのライブラリです。

- *GoogleMobileAds*

アプリに広告を設置するためのライブラリです。

## バージョン管理
GitHubを使用。

## デザインパターン
MVモデルを使用。

## 参考情報
SSHサーバーの環境がない場合は、下記のようなサービスを検討ください。
- *Test.Rebex.Net: https://test.rebex.net*

## デモ画面
![demo](https://github.com/user-attachments/assets/032bedd1-9426-4100-9f1d-2a10c4697dbd)
