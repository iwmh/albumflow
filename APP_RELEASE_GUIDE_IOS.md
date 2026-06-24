# iOS - App Store公開ガイド

メインガイド: [APP_RELEASE_GUIDE.md](APP_RELEASE_GUIDE.md)

このドキュメントでは、FlutterアプリをApp Storeに公開するための詳細な手順を説明します。

---

## 目次

1. [用語と概念の解説](#1-用語と概念の解説)
2. [Apple Developer Portal での設定](#2-apple-developer-portalでの設定)
3. [Xcodeでの初期設定](#3-xcodeでの初期設定)
4. [GitHub Actionsによる自動ビルド・配信](#4-github-actionsによる自動ビルド配信)
   - [4.5 Firebase App Distribution に必要な GitHub Secrets](#45-build-ios-yml-firebase-app-distribution-に必要な-github-secrets)
   - [4.6 App Store / TestFlight に必要な GitHub Secrets](#46-deploy-ios-yml-app-store--testflight-に必要な-github-secrets)
5. [App Store Connectでの設定](#5-app-store-connectでの設定)
6. [TestFlightでのテスト](#6-testflightでのテスト)
7. [本番公開](#7-本番公開)
8. [トラブルシューティング](#8-トラブルシューティング)

---

## 1. 用語と概念の解説

iOSアプリの配信には、Apple独自の概念がいくつか登場します。作業前に理解しておくことで、手順全体が把握しやすくなります。

### Apple ID

Appleのサービスを利用するための個人アカウントです。App StoreやiCloudで使うものと同じです。
Apple Developer Programへの登録もこのApple IDで行います。

### Apple Developer Program

iOS アプリをApp Storeで公開するために加入が必要な有料プログラムです（年間 $99 ≈ 15,000円）。
加入することで以下が可能になります:

- App Storeにアプリを公開する
- 証明書やプロビジョニングプロファイルを発行する
- TestFlight でテスターにアプリを配布する

### 証明書 (Certificate)

**「このアプリはAppleに認められた開発者が作った」ことを証明するデジタル署名**です。

銀行印のようなもので、アプリに押すことで「誰が作ったか」を保証します。

| 証明書の種類 | 用途 |
|--------|------|
| Apple Development | 開発・デバッグ用（自分のデバイスで実行するとき） |
| Apple Distribution | App Store / TestFlight への配布用 |

証明書は以下の2つがセットになって機能します:
- **公開鍵（証明書本体）**: Apple Developer Portal からダウンロードできる
- **秘密鍵**: 証明書を作ったMacのキーチェーン内にのみ存在する

このため、証明書を作ったMacが壊れると秘密鍵が失われ、証明書も使えなくなります。
`fastlane match` を使うとこの問題を回避できます（後述）。

### プロビジョニングプロファイル (Provisioning Profile)

**「このアプリを、どの証明書で署名して、どこに配布していいか」をまとめた許可証**です。

以下の情報が含まれています:
- App ID（アプリの識別子）
- 使用する証明書
- 配布方法（App Store / TestFlight / AdHoc など）

証明書とプロビジョニングプロファイルが両方揃って初めて、アプリをビルドして配布できます。

| プロファイルの種類 | 用途 |
|------|------|
| App Store | App Store / TestFlight への配布 |
| Ad Hoc | 特定の限られたデバイスへの配布（Firebase App Distributionなど） |
| Development | 開発中の実機テスト |

### App Store Connect

AppleがApp Storeを管理するためのWebサービスです。以下の操作に使います:

- アプリの登録・メタデータ（説明文、スクリーンショット等）の管理
- ビルドのアップロード状況の確認
- TestFlight でのテスター管理
- App Storeへの審査申請

### TestFlight

App Storeへ正式公開する前に、限られたテスターにアプリを配布できるAppleのテストプラットフォームです。
ビルドをApp Store Connectにアップロードすると、TestFlight 経由でテスターに配布できます。

| テスターの種類 | 人数上限 | 審査 |
|---|---|---|
| 内部テスター（App Store Connectのチームメンバー） | 最大100人 | 不要 |
| 外部テスター（メールで招待） | 最大10,000人 | Appleの審査が必要 |

### App Store Connect API キー

App Store ConnectへのアクセスをApple IDなしで行うための認証キーです。
GitHub ActionsなどのCI環境では対話的なApple IDログインができないため、このAPIキーを使って認証します。

- **キーID**: APIキーを識別する短い文字列（例: `ABC1234567`）
- **発行者ID**: APIキーを発行した組織のID（UUID形式）
- **.p8 ファイル**: 秘密鍵ファイル。ダウンロードは一度しかできないため厳重に保管する

### Fastlane

ビルド・署名・アップロードなどの繰り返し作業を自動化するツールです。
このプロジェクトでは GitHub Actions のワークフローから Fastlane を呼び出してビルド・配信を行います。

### fastlane match

証明書とプロビジョニングプロファイルをGitリポジトリで暗号化管理するFastlaneの機能です。

「証明書を作ったMacが壊れたら使えなくなる問題」を解消します。
証明書を暗号化してGitリポジトリに保存しておくことで、GitHub Actionsのような CI 環境からも同じ証明書を安全に取得・使用できます。

---

## 2. Apple Developer Portal での設定

[Apple Developer Portal](https://developer.apple.com/account/) にアクセスし、「Certificates, Identifiers & Profiles」から設定します。

### 2.1 App ID の作成

App ID は「このアプリ」をAppleが識別するための一意なIDです。1つのアプリにつき1つ作成します。

1. 「Identifiers」→「+」ボタン
2. 「App IDs」→「Continue」
3. 「App」を選択
4. Description: `AlbumFlow for Spotify`
5. Bundle ID: `com.iwmh.albumflow`（Explicit）
6. Capabilities: 必要な機能を選択（Push Notificationsなど）

### 2.2 証明書の作成

> **`fastlane match` を使う場合、手動での証明書作成は不要です。** `match` が自動で発行・管理します。

手動で作成する場合:

1. 「Certificates」→「+」ボタン
2. 「Apple Distribution」を選択（App Store / TestFlight 配布用）
3. CSR（Certificate Signing Request）をアップロード
   - Mac の「キーチェーンアクセス」→「証明書アシスタント」→「認証局に証明書を要求」
   - 「ディスクに保存」でCSRファイルを生成
4. CSRをアップロードして証明書をダウンロード
5. ダウンロードした `.cer` ファイルをダブルクリックしてキーチェーンにインストール

> ダブルクリックでインストールできない場合は、「キーチェーンアクセス」→「ログイン」→「証明書」→「ファイルから読み込む」で手動インストールします。

### 2.3 プロビジョニングプロファイルの作成

> **`fastlane match` を使う場合、手動でのプロビジョニングプロファイル作成も不要です。**

手動で作成する場合:

1. 「Profiles」→「+」ボタン
2. 「App Store Connect」を選択
3. App ID（`com.iwmh.albumflow`）を選択
4. 証明書を選択
5. プロファイル名を入力（例: `AlbumFlow for Spotify App Store`）
6. ダウンロードして Xcode にインストール

---

## 3. Xcodeでの初期設定

初回セットアップ時のみ Xcode で確認・設定します。

```bash
# ios フォルダ内の Xcworkspace を開く
open ios/Runner.xcworkspace
```

**設定項目:**

1. **General タブ**
   - Display Name: `AlbumFlow for Spotify`
   - Bundle Identifier: `com.iwmh.albumflow`
   - Version / Build: `pubspec.yaml` の値と合わせる

2. **Signing & Capabilities タブ**
   - Team: 自分のApple Developerアカウント
   - Bundle Identifier: `com.iwmh.albumflow`
   - Automatically manage signing: ローカル開発時は有効で問題なし（CI では Fastlane match が管理する）

3. **Build Settings タブ**
   - iOS Deployment Target: `13.0` 以上（Flutter は iOS 13+ をサポート）

---

## 4. GitHub Actionsによる自動ビルド・配信

ビルドと App Store Connect へのアップロードは **GitHub Actions が自動で行います**。手動でビルドコマンドを実行する必要はありません。

ワークフローの詳細設定（YAMLファイル、シークレット一覧、Fastfile等）は [APP_RELEASE_GUIDE.md - Section 2](APP_RELEASE_GUIDE.md#2-github-actionsによる自動化) を参照してください。

### 4.1 配信フロー

```
pubspec.yaml のバージョンを更新（version: 1.0.1+2 など）
    ↓
git commit && git tag v1.0.1 && git push origin v1.0.1
    ↓
GitHub Actions (deploy-ios.yml) が自動起動
    ↓
Fastlane が match で Git リポジトリから証明書を取得
    ↓
Flutter で IPA ビルド
    ↓
App Store Connect へ自動アップロード
    ↓
TestFlight または App Store へ配信
```

### 4.2 手動実行

任意のタイミングで配信したい場合は手動で実行できます:

1. GitHub の「Actions」タブを開く
2. 「Deploy iOS」ワークフローを選択
3. 「Run workflow」をクリック
4. `destination` で `testflight`（テスト配信）または `appstore`（本番配信）を選択
5. 「Run workflow」で実行

### 4.3 バージョン番号の更新

配信前に `pubspec.yaml` でバージョンを更新します:

```yaml
version: 1.0.0+1
# 形式: major.minor.patch+buildNumber
# 1.0.0 = CFBundleShortVersionString（App Storeでユーザーに表示される）
# +1    = CFBundleVersion（ストア内部で使用。公開ごとに必ず増やす）
```

**バージョン番号のルール:**
- `buildNumber`（`+` 以降の数字）は公開ごとに**必ず増やす**
- 一度 App Store Connect にアップロードしたビルド番号は再利用できない

### 4.4 初回セットアップ: fastlane match の初期化

> **初回のみ必要な作業です。** 証明書リポジトリがすでに存在する場合はスキップしてください。

fastlane match は証明書をGitリポジトリで管理します。初回は以下を実行して証明書を発行し、Gitリポジトリに保存します:

```bash
cd ios
bundle install
bundle exec fastlane match appstore --generate
```

実行後、証明書とプロビジョニングプロファイルが暗号化されてGitリポジトリに保存されます。以降は GitHub Actions が自動で取得します。

#### コマンドの詳細解説

上記のコマンドが何をしているか、順番に説明します。

---

##### `bundle install` とは

**Bundler（バンドラー）** というツールを使って、このプロジェクトに必要な Ruby のライブラリ（gem）を一括インストールするコマンドです。

少したとえ話をすると——

> Flutter プロジェクトの `pubspec.yaml` に使いたいパッケージを書いて `flutter pub get` すると必要なものが揃いますよね。それと全く同じ仕組みが Ruby にもあります。Ruby では `Gemfile` がパッケージ一覧ファイル、`bundle install` が `flutter pub get` に相当します。

`ios/Gemfile` には次のように書かれています：

```
gem "fastlane"    ← デプロイ自動化ツール
gem "cocoapods"   ← iOS ライブラリ管理ツール
gem "multi_json"  ← JSON処理ライブラリ（fastlaneが内部で使用）
```

`bundle install` を実行すると、これらが `~/.rbenv/versions/3.3.7/lib/ruby/gems/` にダウンロード・インストールされます。あわせて `Gemfile.lock` が作成または更新され、「どのバージョンをインストールしたか」が記録されます。これにより、自分のMacでも GitHub Actions の CI 環境でも、常に同じバージョンが使われることが保証されます。

---

##### `bundle exec` とは

`bundle exec` は、続くコマンドを「`bundle install` でインストールしたバージョンのライブラリで実行する」という意味のおまじないです。

`bundle exec` なしで単に `fastlane ...` と打つと、Mac にグローバルインストールされた別バージョンの fastlane が使われてしまう可能性があります。`bundle exec` をつけることで「このプロジェクト専用の fastlane を使う」ことが保証されます。

---

##### `fastlane match appstore --generate` とは

**fastlane** は iOS/Android のビルド・署名・ストア提出などを自動化するツールです。その中の **match** という機能が証明書の管理を担当します。

このコマンドが内部でやっていることを順番に説明します：

```
① Apple Developer Portal に接続
      ↓
② App Store 配布用の「証明書」と「プロビジョニングプロファイル」を発行
      ↓
③ 入力したパスフレーズで暗号化
      ↓
④ Matchfile に書かれた GitHub リポジトリ（例: github.com/iwmh/certificates）に保存
      ↓
⑤ あなたの Mac にもインストール（ローカルビルド用）
```

各オプションの意味：

| オプション | 意味 |
|---|---|
| `appstore` | App Store / TestFlight 配布用の証明書・プロファイルを対象にする |
| `--generate` | 既存のものがなければ新規発行する |

**なぜ Git リポジトリに保存するのか？**

証明書は「どの Mac で作ったか」に依存します。Mac が壊れたり、チームに別の開発者が加わったりすると、証明書が使えなくなります。Git リポジトリに暗号化して保存しておくことで、どの環境（GitHub Actions も含む）からでも同じ証明書を取り出して使えるようになります。

**パスフレーズの入力を求められたら？**

コマンド実行中に次のようなプロンプトが表示されます：

```
Passphrase for Match storage:
```

ここで入力するのは「証明書を暗号化するための自分で決めるパスワード」です。このパスワードは後で GitHub Secrets の `MATCH_PASSWORD` に登録します。**絶対に忘れないようにメモしておいてください。**

---

### 4.5 `build-ios.yml`（Firebase App Distribution）に必要な GitHub Secrets

`build-ios.yml` は CI ワークフロー（`ci.yml`）が成功した後に自動実行され、AdHoc 署名した IPA を Firebase App Distribution 経由でテスターに配布します。

GitHub リポジトリの **Settings → Secrets and variables → Actions** に以下を登録してください。

#### 必要なシークレット一覧

| シークレット名 | 説明 | 取得方法 |
|---|---|---|
| `APP_STORE_CONNECT_API_KEY_BASE64` | App Store Connect APIキー `.p8` ファイルを Base64 エンコードしたもの | 下記参照 |
| `APP_STORE_CONNECT_API_KEY_ID` | APIキーID（例: `ABC123DEFG`） | App Store Connect → ユーザーとアクセス → キー |
| `APP_STORE_CONNECT_API_ISSUER_ID` | 発行者ID（UUID形式） | 同ページ上部の「発行者ID」 |
| `MATCH_PASSWORD` | fastlane match で証明書リポジトリを暗号化する際のパスワード | 初回 `match` 実行時に自分で設定した任意のパスワード |
| `MATCH_GIT_BASIC_AUTHORIZATION` | 証明書リポジトリへの Git Basic 認証情報 | 下記参照 |
| `IOS_TEAM_ID` | Apple Developer Team ID（例: `A1B2C3D4E5`） | developer.apple.com → Account → Membership |
| `FIREBASE_APP_ID_IOS` | Firebase iOS アプリの アプリ ID | 下記参照 |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Firebase へのアップロード権限を持つサービスアカウントの JSON | 下記参照 |

#### 各シークレットの詳細な取得手順

**`APP_STORE_CONNECT_API_KEY_BASE64`**

AdHoc 署名に使う証明書を fastlane match が Apple Developer Portal から取得するための認証キーです。

1. [App Store Connect](https://appstoreconnect.apple.com/) → ユーザーとアクセス → キー
2. 「+」ボタンでキーを生成（ロール: **App Manager**）
3. **キーID** と **発行者ID** をメモ（それぞれ後続のシークレットに使用）
4. `.p8` ファイルをダウンロード（**ダウンロードは一度のみ**、以降再取得不可）
5. ローカルで Base64 エンコードしてクリップボードにコピー:
   ```bash
   base64 -i AuthKey_XXXXXXXXXX.p8 | pbcopy
   ```
6. クリップボードの内容をシークレット `APP_STORE_CONNECT_API_KEY_BASE64` として登録

**`MATCH_GIT_BASIC_AUTHORIZATION`**

fastlane match が証明書を保存・取得する Git リポジトリへの認証情報です。

1. GitHub の Settings → Developer settings → Personal access tokens → Tokens (classic)
2. 「Generate new token」→ スコープ: `repo`（証明書リポジトリへの read/write 権限）
3. 生成されたトークン（`ghp_XXXXXXXXXX`）をメモ
4. ローカルで Base64 エンコード:
   ```bash
   echo -n "GitHubユーザー名:ghp_XXXXXXXXXX" | base64 | pbcopy
   ```
   > `echo -n` の `-n` は改行なし出力のためのフラグです。**必ず付けてください**（改行が含まれると認証に失敗します）
5. クリップボードの内容をシークレット `MATCH_GIT_BASIC_AUTHORIZATION` として登録

**`FIREBASE_APP_ID_IOS`**

1. [Firebase Console](https://console.firebase.google.com/) → 対象プロジェクトを開く
2. 左上の歯車アイコン → **プロジェクトの設定**
3. 「全般」タブ → 「マイアプリ」セクション内の iOS アプリ（`com.iwmh.albumflow`）を選択
4. **アプリ ID** をコピー（形式: `1:123456789012:ios:abcdef1234567890`）

> Firebase でまだ iOS アプリを登録していない場合は、[APP_RELEASE_GUIDE.md の STEP 3](APP_RELEASE_GUIDE.md#step-3-ios-アプリを登録) を参照してください。

**`FIREBASE_SERVICE_ACCOUNT_JSON`**

GitHub Actions から Firebase App Distribution にアップロードするための認証情報です。

1. [Google Cloud Console](https://console.cloud.google.com/) → 画面上部のプロジェクト選択で Firebase と同じプロジェクトを選択
2. 左メニュー「IAM と管理」→「サービスアカウント」
3. 「サービスアカウントを作成」をクリック
   - 名前: `github-actions-firebase`（任意）
   - 「作成して続行」
4. ロールを付与: 「ロールを選択」→ **`Firebase App Distribution 管理者`** を検索して選択 → 「続行」→「完了」
5. 作成したサービスアカウントの行をクリック →「キー」タブ
6. 「鍵を追加」→「新しい鍵を作成」→「JSON」→「作成」
7. ダウンロードされた JSON ファイルの**中身（テキスト全体）** をシークレット `FIREBASE_SERVICE_ACCOUNT_JSON` として登録（ファイルパスではなく内容そのもの）

---

#### Google Cloud Console の作業を初心者向けに解説

上の手順を読んで「なぜこんなことをするの？」と感じた方のために、背景知識から順を追って説明します。

---

##### そもそも Google Cloud Console とは？

Firebase は Google のサービスですが、実は内部的には **Google Cloud Platform（GCP）** というクラウド基盤の上で動いています。

> **たとえ話**: Firebase は「コンビニ」、Google Cloud Platform は「コンビニが入っているビル全体」のようなイメージです。Firebase を使うと、自動的に同じ名前の GCP プロジェクトも作られています。

**Google Cloud Console** は、この GCP プロジェクトの設定や管理を行うための Web サイトです。Firebase Console とは別のサイトですが、同じプロジェクトを管理しています。

---

##### なぜ Firebase Console ではなく Google Cloud Console を使うのか？

Firebase App Distribution へのアップロード権限を GitHub Actions に与えるには、**Google Cloud の「サービスアカウント」** という仕組みを使う必要があります。この機能は Google Cloud Console 側にしかないため、わざわざ GCP のサイトを開きます。

---

##### 「サービスアカウント」とは何か？

通常の Google アカウント（Gmail アドレスとパスワードでログインするもの）は **人間が使うもの** です。

一方、**サービスアカウント**は **プログラム（機械）が使うための特別なアカウント** です。

| | 通常のアカウント | サービスアカウント |
|---|---|---|
| 使う主体 | 人間 | プログラム・サーバー・CI など |
| ログイン方法 | メール + パスワード（対話的） | JSON キーファイル（自動） |
| 例 | あなた自身の Gmail | GitHub Actions |

GitHub Actions は自動で動くロボットなので、「メールアドレスとパスワードを入力してログイン」という人間的な操作ができません。そこで、JSON ファイルを使って自動ログインできるサービスアカウントを使います。

---

##### 「IAM と管理」→「サービスアカウント」とは何か？

**IAM（Identity and Access Management）** は、「誰に、何の操作を許可するか」を管理する仕組みです。

> **たとえ話**: 会社のビルにはいろんな部屋があります。社員全員がすべての部屋に入れると危険なので、「営業の人は営業エリアだけ」「エンジニアはサーバー室も OK」と鍵カードで制限しますよね。IAM はこの「鍵カードの管理システム」です。

「サービスアカウント」はその IAM システムで管理される「ロボット用のアカウント」です。

---

##### 「ロールを付与」とは何か？

**ロール（役割）** とは、「この操作が許可されている」という権限のセットです。

たとえば **`Firebase App Distribution 管理者`** というロールには、「Firebase App Distribution にアプリをアップロードする」「テスターにアプリを配布する」などの権限が含まれています。

> **たとえ話**: アルバイトを雇うとき、「レジ担当」として採用すれば、レジ打ちはできるけど金庫は触れない、という役割が決まります。これがロールです。

最小限の権限だけ与えることが重要です（必要以上の権限を与えると、万が一 JSON キーが漏れたとき被害が大きくなります）。

今回 `Firebase App Distribution 管理者` だけを付けるのは、「GitHub Actions には App Distribution へのアップロードだけ許可し、それ以外（ユーザーデータの閲覧、Firestore の操作など）は一切できないようにする」ためです。

---

##### JSON キーファイルとは何か？

サービスアカウントを作っただけでは、GitHub Actions はまだそのアカウントを使えません。**「このサービスアカウントだと証明するための鍵ファイル」** が必要です。それが JSON キーファイルです。

ダウンロードされる JSON はこんな内容です（実際は値が長い文字列になります）:

```json
{
  "type": "service_account",
  "project_id": "your-firebase-project-id",
  "private_key_id": "abcd1234...",
  "private_key": "-----BEGIN RSA PRIVATE KEY-----\n...\n-----END RSA PRIVATE KEY-----\n",
  "client_email": "github-actions-firebase@your-project.iam.gserviceaccount.com",
  "client_id": "123456789",
  ...
}
```

- `client_email`: サービスアカウントのメールアドレス（識別子）
- `private_key`: サービスアカウントの秘密鍵（これが「パスワード」に相当する）

GitHub Actions はこの JSON を使って「私は `github-actions-firebase` サービスアカウントです」と Google に証明し、Firebase App Distribution へのアップロードを行います。

---

##### 手順の全体像（まとめ）

```
① Google Cloud Console で「サービスアカウント」を作る
   → GitHub Actions 用のロボットアカウントを用意する

② ロールを付与する（Firebase App Distribution 管理者）
   → そのロボットに「Firebase App Distribution だけ触れる権限」を与える

③ JSON キーを発行する
   → ロボットが Google に「自分はこのアカウントです」と証明するための鍵を作る

④ JSON の内容を GitHub Secrets に登録する
   → GitHub Actions がその鍵を安全に使えるようにする
```

---

> **セキュリティ上の注意**: この JSON ファイルは秘密鍵を含む非常に重要なファイルです。絶対に Git にコミットしないでください。ダウンロード後はすぐに GitHub Secrets に登録し、ローカルのファイルは削除することを推奨します。

---

### 4.6 `deploy-ios.yml`（App Store / TestFlight）に必要な GitHub Secrets

`deploy-ios.yml` は手動実行（workflow_dispatch）でトリガーし、TestFlight（内部テスト）または App Store Connect（本番リリース）にビルドをアップロードします。

#### 必要なシークレット一覧

| シークレット名 | 説明 | 取得方法 |
|---|---|---|
| `APP_STORE_CONNECT_API_KEY_BASE64` | App Store Connect APIキー `.p8` を Base64 エンコード | Section 4.5 参照 |
| `APP_STORE_CONNECT_API_KEY_ID` | APIキーID | Section 4.5 参照 |
| `APP_STORE_CONNECT_API_ISSUER_ID` | 発行者ID | Section 4.5 参照 |
| `MATCH_PASSWORD` | fastlane match の証明書リポジトリ暗号化パスワード | Section 4.5 参照 |
| `MATCH_GIT_BASIC_AUTHORIZATION` | 証明書リポジトリへの Git Basic 認証情報 | Section 4.5 参照 |
| `IOS_TEAM_ID` | Apple Developer Team ID | Section 4.5 参照 |
| `APPLE_ID` | Apple ID のメールアドレス | 自身の Apple Developer アカウントのメールアドレス |

#### App Store への自動アップロード フロー

```
GitHub Actions → 「Deploy iOS」を手動実行
    ↓
destination: appstore を選択
    ↓
flutter pub get → pod install → flutter build ios（コード署名なし）
    ↓
fastlane match で App Store 用証明書・プロビジョニングプロファイルを取得
    ↓
build_app（xcodebuild archive + export）で署名済み IPA を生成
    ↓
upload_to_app_store（altool / API）で App Store Connect に自動アップロード
    ↓
App Store Connect 上で審査へ提出操作（手動）
```

> **TestFlight へのアップロード**: `destination: testflight` を選択すると、同じ流れで TestFlight にアップロードされます。内部テスターはアップロード後すぐに配信可能です。

#### 実行手順

1. GitHub リポジトリの「Actions」タブを開く
2. 左サイドバーの「Deploy iOS」をクリック
3. 右上の「Run workflow」をクリック
4. `destination` を選択:
   - `testflight`: TestFlight にアップロード（テスト配信）
   - `appstore`: App Store Connect にアップロード（本番リリース準備）
5. 「Run workflow」で実行

> **App Store 審査提出**: ワークフロー完了後、App Store Connect でビルドを確認し、審査提出は手動で行います（[Section 7](#7-本番公開) 参照）。自動提出したい場合は Fastfile の `release` レーン内 `upload_to_app_store` の `submit_for_review: false` を `true` に変更してください。

---

## 5. App Store Connectでの設定

### 5.1 アプリの作成

1. [App Store Connect](https://appstoreconnect.apple.com/) にアクセス
2. 「マイApp」→「+」→「新規App」
3. 以下を入力:
   - プラットフォーム: iOS
   - 名前: `AlbumFlow for Spotify`
   - プライマリ言語: 日本語
   - バンドルID: `com.iwmh.albumflow`
   - SKU: `albumflow-001`（任意の一意な文字列）

### 5.2 App情報の設定

**App情報タブ:**
- 名前（ストアに表示）
- サブタイトル（30文字以内）
- カテゴリ: ミュージック
- コンテンツ配信権: 該当なし
- 年齢制限指定: 質問に回答

**価格および配信状況:**
- 価格: 無料
- 配信する国/地域を選択

### 5.3 バージョン情報

**App Store タブ:**
- スクリーンショット（必須）
  - 6.7インチ（iPhone 15 Pro Max）: 1290 x 2796
  - 6.5インチ（iPhone 11 Pro Max）: 1284 x 2778
  - 5.5インチ（iPhone 8 Plus）: 1242 x 2208
  - iPad Pro 12.9インチ: 2048 x 2732
- プロモーションテキスト（170文字以内）
- 概要（4000文字以内）
- キーワード（100文字以内、カンマ区切り）
- サポートURL
- マーケティングURL（オプション）
- プライバシーポリシーURL

### 5.4 App Review情報

- 連絡先情報
- サインイン情報（テストアカウント）
- 添付ファイル（必要に応じて）
- 備考（審査員への説明）

---

## 6. TestFlightでのテスト

GitHub Actions がビルドをアップロードすると、自動的に TestFlight から配信可能になります。

1. App Store Connect で「TestFlight」タブを開く
2. ビルドの処理完了を待つ（約15〜30分）
3. テスターを追加:
   - **内部テスター**: チームメンバーを「ユーザーとアクセス」から追加。審査不要でほぼ即時配信可能
   - **外部テスター**: 「テスターを追加」からメールアドレスを登録。Appleの審査（1〜2日）後に配信

---

## 7. 本番公開

1. App Store タブで「ビルド」を選択（TestFlight 処理済みのビルドから選ぶ）
2. 「審査へ提出」
3. Appleの審査（通常1〜3日）
4. 承認後、自動公開または手動公開を選択

---

## 8. トラブルシューティング

### 8.1 署名エラー

```
No signing certificate "iOS Distribution" found
```

→ GitHub Actions のシークレット設定を確認する:
- `MATCH_PASSWORD` が正しいか
- `MATCH_GIT_BASIC_AUTHORIZATION` の Base64 値が正しいか（`echo -n "user:token" | base64` の形式）

### 8.2 GitHub Actions のビルド失敗

1. 「Actions」タブ → 失敗したワークフローをクリック
2. 赤くなっているステップをクリックして詳細ログを確認

よくある原因:
- シークレットの名前のスペルミス、または Base64 エンコード漏れ
- Fastfile / Matchfile の記述ミス
- CocoaPods のキャッシュ問題

### 8.3 ローカルでビルドを確認したい場合

```bash
cd ios
pod deintegrate
pod install
cd ..
fvm flutter clean
fvm flutter pub get
fvm flutter build ipa --release
```
