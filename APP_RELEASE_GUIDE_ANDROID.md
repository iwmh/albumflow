# Android - Google Play Store公開ガイド

メインガイド: [APP_RELEASE_GUIDE.md](APP_RELEASE_GUIDE.md)

このドキュメントでは、FlutterアプリをGoogle Play Storeに公開するための詳細な手順を説明します。

---

## 目次

1. [AndroidManifestとは](#1-androidmanifestとは)
2. [AndroidManifestの確認](#2-androidmanifestの確認)
3. [Material Componentsの有効化](#3-material-componentsの有効化)
4. [なぜ署名が必要なのか](#4-なぜ署名が必要なのか)
5. [署名キーの作成](#5-署名キーの作成)
6. [署名設定](#6-署名設定)
7. [リリースビルドの作成](#7-リリースビルドの作成)
8. [Google Play Consoleでの設定](#8-google-play-consoleでの設定)
9. [内部テストへの公開](#9-内部テストへの公開)
10. [本番公開](#10-本番公開)
11. [トラブルシューティング](#11-トラブルシューティング)
12. [GitHub Actionsによる自動デプロイ](#12-github-actionsによる自動デプロイ)

---

## 1. AndroidManifestとは

### 1.1 歴史と背景

AndroidManifest.xml は、Androidプラットフォームの誕生（2008年）と同時に設計された「アプリの申告書」です。

Android が目指したのは、**サンドボックス型のセキュリティモデル**でした。各アプリは独立したLinuxユーザーIDで動作し、他のアプリやシステムリソースへのアクセスは原則として遮断されます。この仕組みの中で「このアプリが何であり、何をしたいか」をOS側に事前に宣言させる仕組みが必要になりました。それがManifestです。

初期のAndroid（API 1）ではシンプルな構造でしたが、バージョンを重ねるごとにマルチタスク、大画面対応、権限の細分化、セキュリティ強化が加わり、現在の複雑な構造に進化しています。

### 1.2 なぜ必要なのか

AndroidのOSはアプリをインストール・起動する際、まずManifestを解析します。この宣言がなければOSはアプリについて何も知ることができません。

| Manifestで宣言すること | 理由 |
|----------------------|------|
| アプリ名・アイコン | ランチャーやストアに表示するため |
| パッケージ名（アプリID） | システム上で一意にアプリを識別するため |
| アクティビティ・サービスの一覧 | OSが起動・管理できるコンポーネントを把握するため |
| 権限（`uses-permission`） | ユーザーへの事前開示とOSによるアクセス制御のため |
| 対応APIレベル | 互換性のないデバイスへのインストールを防ぐため |

特に権限モデルは重要で、「アプリはカメラを使いたい」という意図をManifestで宣言し、実行時にユーザーが承認するという2段階の仕組みになっています。Manifestへの記載なしに権限を実行時リクエストすることはできません。

### 1.3 Flutterプロジェクトにおける位置づけ

Flutter アプリのManifestは `android/app/src/main/AndroidManifest.xml` に存在します。Flutterツールとプラグインが自動でマージ・更新するケースもありますが、**インターネット接続・カメラ・位置情報などの権限追加は手動で行う必要があります**。公開前に必ず内容を確認するのが重要なのはこのためです。

---

## 2. AndroidManifestの確認

デフォルトの[App Manifest](https://developer.android.com/guide/topics/manifest/manifest-intro)ファイルを確認します。

**`android/app/src/main/AndroidManifest.xml`:**

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="AlbumFlow for Spotify"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        ...
    </application>
    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

**確認項目:**

| 要素 | 説明 |
|------|------|
| `android:label` | アプリ名（ストアとデバイスに表示） |
| `android:icon` | アプリアイコンへの参照 |
| `uses-permission` | インターネット接続が必要な場合は`INTERNET`権限を追加 |

---

## 3. Material Componentsの有効化

アプリが[platform views](https://docs.flutter.dev/platform-integration/android/platform-views)を使用する場合、Material Componentsを有効化することを推奨します。

**1. `android/app/build.gradle.kts`に依存関係を追加:**

```kotlin
dependencies {
    // ...
    implementation("com.google.android.material:material:1.11.0")
    // 最新バージョンは https://maven.google.com/ で確認
}
```

**2. `android/app/src/main/res/values/styles.xml`のライトテーマを設定:**

```xml
-<style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
+<style name="NormalTheme" parent="Theme.MaterialComponents.Light.NoActionBar">
```

**3. `android/app/src/main/res/values-night/styles.xml`のダークテーマを設定:**

```xml
-<style name="NormalTheme" parent="@android:style/Theme.Black.NoTitleBar">
+<style name="NormalTheme" parent="Theme.MaterialComponents.DayNight.NoActionBar">
```

詳細は[Material Components for Android](https://m3.material.io/develop/android/mdc-android)を参照してください。

---

## 4. なぜ署名が必要なのか

### 4.1 歴史と背景

コード署名の概念は1990年代に生まれました。インターネットの普及とともにソフトウェアがネットワーク経由で配布されるようになると、「このソフトウェアは本当に名乗っている開発者が作ったものか」「配布途中に改ざんされていないか」を検証する手段が不可欠になりました。

Microsoftが1994年に[Authenticode](https://learn.microsoft.com/en-us/windows-hardware/drivers/install/authenticode)を導入したのを皮切りに、Appleも同様の仕組みをmacOS・iOSに採用し、Androidはプラットフォーム設計の段階から署名を**必須要件**として組み込みました。

Androidにおける署名の具体的な歴史：

| 時期 | 出来事 |
|------|------|
| 2008年 Android 1.0 | 署名が必須化。自己署名証明書を許可（認証局不要） |
| 2017年 Android 7.0 | APK Signature Scheme v2 導入。APK全体への署名で改ざん検知を強化 |
| 2018年 Android 9.0 | APK Signature Scheme v3 導入。鍵のローテーション（更新）が可能に |
| 2022年 Android 13 | v4スキームによりインクリメンタルインストール対応 |
| 現在 | Google Play は Upload Key と App Signing Key を分離管理 |

### 4.2 なぜ必要なのか

署名には主に3つの目的があります。

**1. 開発者の同一性の証明（なりすまし防止）**

同じパッケージ名（アプリID）を持つアプリであっても、**署名が異なれば別のアプリ**としてAndroidは扱います。これにより、悪意ある第三者が「同一アプリの更新版」を装って偽アプリをインストールさせることを防ぎます。

**2. 改ざん検知**

署名はAPK/AABファイル全体のハッシュ値を秘密鍵で暗号化したものです。インストール時にAndroidは公開鍵でこれを検証します。配布中にファイルが1バイトでも変更されていれば、インストールは拒否されます。

**3. アプリ更新の継続性の保証**

Androidは「同一署名＝同一開発者」と判断します。そのため、アプリの更新には**最初のリリースと同じ秘密鍵で署名**しなければなりません。これがキーストアの紛失が取り返しのつかない問題になる理由です。

```
┌─────────────────────────────────────────────────────┐
│                  署名の仕組み（概要）                  │
└─────────────────────────────────────────────────────┘

開発者（あなた）
  ├── 秘密鍵（keystore）→ APK/AABに署名 → 配布
  └── 公開鍵（証明書）→ APKに同梱

Android OS（インストール時）
  ├── APK同梱の公開鍵で署名を検証
  ├── ファイルの改ざんチェック
  └── 既インストールアプリと署名が一致するか確認
```

### 4.3 Google Play の「アプリ署名」プログラムについて

現在のGoogle Playでは、**Upload KeyとApp Signing Keyが分離**されています。

- **Upload Key（アップロードキー）**: 開発者がGoogleにAABをアップロードする際に使う鍵。手元で管理。
- **App Signing Key（アプリ署名キー）**: Googleがユーザーに配布する際に実際に使う鍵。Google が安全に管理。

この仕組みにより、Upload Keyを紛失してもGoogleに申請すれば鍵を再発行できるという利点があります。これはかつての「鍵をなくしたら二度とアップデートを出せない」という問題への対応策として2017年に導入されました。

⚠️ なお、**このガイドの手順で作成するキーはUpload Keyです**。初回アップロード時にGoogle Playのアプリ署名プログラムへ自動的に登録されます。

---

## 5. 署名キーの作成

アプリに署名するためのキーストアを作成します。

**Windows (PowerShell):**
```powershell
keytool -genkey -v -keystore "$env:USERPROFILE\upload-keystore.jks" `
        -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 `
        -alias upload
```

**macOS/Linux:**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA \
        -keysize 2048 -validity 10000 -alias upload
```

**入力項目:**
- キーストアのパスワード（忘れないように！）
- 名前（本名）
- 組織単位
- 組織名
- 市区町村
- 都道府県
- 国コード（JP）

⚠️ **重要:** キーストアファイルとパスワードは**絶対に紛失しないでください**。紛失するとアプリの更新ができなくなります。

---

## 6. 署名設定

### 6.1 key.properties ファイルの作成

`android/key.properties` を作成（**Gitにコミットしない**）:

```properties
storePassword=<キーストアのパスワード>
keyPassword=<キーのパスワード>
keyAlias=upload
storeFile=<キーストアファイルへの絶対パス>
```

**storeFileのパス例:**
- Windows: C:\\Users\\<ユーザー名>\\upload-keystore.jks（バックスラッシュを2つ `\\` にする）
- macOS/Linux: `/Users/<ユーザー名>/upload-keystore.jks`

⚠️ **注意:** Windowsではパスのバックスラッシュを `\\` とエスケープする必要があります。

### 6.2 .gitignore に追加

```gitignore
# Android signing
android/key.properties
*.jks
*.keystore
```

### 6.3 build.gradle.kts の修正

`android/app/build.gradle.kts` を以下のように修正:

```kotlin
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// key.properties を読み込む
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.iwmh.albumflow"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // ⚠️ 重要: applicationId は一度公開したら変更不可
        applicationId = "com.iwmh.albumflow"
        // minSdk: アプリがサポートする最小Androidバージョン
        minSdk = flutter.minSdkVersion
        // targetSdk: アプリが設計・テストされたAndroidバージョン
        targetSdk = flutter.targetSdkVersion
        // versionCode: ストア内部で使用（公開ごとに増やす必要あり）
        versionCode = flutter.versionCode
        // versionName: ユーザーに表示されるバージョン
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            // リリースビルドで署名設定を使用
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
```

⚠️ **注意:** Gradleファイルを変更した後は `flutter clean` を実行してキャッシュをクリアしてください。

### 6.4 R8によるコード縮小

[R8](https://developer.android.com/studio/build/shrink-code)は、Googleの新しいコード圧縮ツールです。リリースビルド（App BundleまたはAPK）では**デフォルトで有効**になっています。

- コード縮小を無効化する場合: `flutter build appbundle --no-shrink` または `flutter build apk --no-shrink`
- 難読化と圧縮により、ビルド時間が大幅に延びる可能性があります

⚠️ **注意:** `--[no-]shrink`フラグは現在効果がありません。リリースビルドでは常にコード縮小が有効です。詳細は[Shrink, obfuscate, and optimize your app](https://developer.android.com/studio/build/shrink-code)を参照してください。

### 6.5 Multidex対応

大規模なアプリや大きなプラグインを使用する場合、最小API 20以下をターゲットにすると、Androidの64kメソッド数制限に達する可能性があります。

**Flutterツールの自動対応:**

1. ビルドエラーが発生すると、Flutterツールが自動的にmultidexの必要性を検出
2. プロンプトで確認を求められ、`y`を入力すると自動設定
3. 自動的に`androidx.multidex:multidex`に依存し、`FlutterMultiDexApplication`を使用

**手動で有効化する場合:**

```bash
# コマンドラインから
fvm flutter run --debug
# プロンプトが表示されたら「y」を入力
```

**IDEでビルドエラーが表示される場合:**
- エラーメッセージのプロンプトに従って有効化

⚠️ **注意:** 
- Android SDK 21以降をターゲットにする場合、multidexはネイティブで含まれています
- 手動でmultidexを設定する場合は、[Android公式ガイド](https://developer.android.com/studio/build/multidex)を参照
- multidex keep fileに以下を含める必要があります:
  ```
  io/flutter/embedding/engine/loader/FlutterLoader.class
  io/flutter/util/PathUtils.class
  ```

---

## 7. リリースビルドの作成

### 7.1 App Bundleのビルド（推奨）

```bash
# 基本コマンド
fvm flutter build appbundle

# コード難読化あり（推奨）
fvm flutter build appbundle --obfuscate --split-debug-info=build/app/outputs/symbols

# バージョン番号を上書き
fvm flutter build appbundle --build-name=1.0.1 --build-number=2

# 出力先: build/app/outputs/bundle/release/app-release.aab
```

**オプション説明:**
- `--obfuscate`: Dartコードを難読化してリバースエンジニアリングを困難にする
- `--split-debug-info`: デバッグシンボルを別ファイルに分離（スタックトレースの解析に必要）
- `--build-name`: `pubspec.yaml`のバージョン名を上書き（Androidの`versionName`）
- `--build-number`: `pubspec.yaml`のビルド番号を上書き（Androidの`versionCode`）

デフォルトで、App Bundleには以下のABI用のコードが含まれます:
- [armeabi-v7a](https://developer.android.com/ndk/guides/abis#v7a) (ARM 32-bit)
- [arm64-v8a](https://developer.android.com/ndk/guides/abis#arm64-v8a) (ARM 64-bit)
- [x86-64](https://developer.android.com/ndk/guides/abis#86-64) (x86 64-bit)

### 7.2 APKのビルド（代替手段）

Google Play Store以外で配布する場合や、ストアがApp Bundleに対応していない場合にAPKを使用します。

```bash
# ABIごとに分割したAPK（推奨）
fvm flutter build apk --split-per-abi

# 出力先:
# - build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk
# - build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
# - build/app/outputs/flutter-apk/app-x86_64-release.apk

# Fat APK（すべてのABIを含む、サイズ大）
fvm flutter build apk
```

**`--split-per-abi`の利点:**
- 各APKのサイズが小さくなる
- ユーザーは自分のデバイスに必要なバイナリのみダウンロード
- Fat APKは不要なネイティブバイナリを含むためサイズが大きい

---

## 8. Google Play Consoleでの設定

### 8.1 アプリの作成

1. Google Play Console にログイン
2. 「アプリを作成」をクリック
3. 以下の情報を入力:
   - アプリ名: `AlbumFlow for Spotify`
   - デフォルトの言語: 日本語
   - アプリまたはゲーム: アプリ
   - 無料または有料: 無料
   - 宣言（各項目にチェック）

### 8.2 ストア掲載情報の設定

**メインのストア掲載情報:**
- アプリ名（30文字以内）
- 簡単な説明（80文字以内）
- 詳しい説明（4000文字以内）
- アプリアイコン（512x512 PNG）
- フィーチャーグラフィック（1024x500 PNG）
- スクリーンショット（最低2枚）
  - 電話: 16:9 または 9:16
  - 7インチタブレット
  - 10インチタブレット

### 8.3 コンテンツのレーティング

質問票に回答してレーティングを取得:
1. 「ポリシー」→「アプリのコンテンツ」→「コンテンツのレーティング」
2. 質問に正直に回答
3. レーティングを取得

### 8.4 プライバシーポリシー

プライバシーポリシーのURLが必要です。
- 自分のWebサイトに掲載
- または GitHub Pages で公開

```markdown
# プライバシーポリシー（例）

## 収集する情報
- Spotifyアカウント情報（認証のため）
- アルバム・プレイリスト情報

## 情報の使用目的
- アプリ機能の提供のみ

## 第三者への提供
- 第三者への提供は行いません

## お問い合わせ
email@example.com
```

---

## 9. 内部テストへの公開

1. 「テスト」→「内部テスト」を選択
2. 「新しいリリースを作成」
3. App Bundle (.aab) をアップロード
4. リリースノートを入力
5. テスターのメールアドレスを追加
6. 「リリースのレビュー」→「内部テストとして公開開始」

---

## 10. 本番公開

内部テストで問題なければ:
1. 「本番」→「新しいリリースを作成」
2. 内部テストからリリースを昇格、またはApp Bundleを再アップロード
3. リリースノートを入力
4. 「リリースのレビュー」→「本番環境として公開開始」
5. Googleの審査（通常1〜3日）

---

## 11. トラブルシューティング

### 11.1 署名エラー

```
Error: Keystore was tampered with, or password was incorrect
```

→ キーストアのパスワードが間違っている。`key.properties` を確認。

### 11.2 R8/ProGuard の問題

#### Missing classes detected while running R8

**エラー例:**
```
ERROR: Missing classes detected while running R8...
Missing class com.google.android.play.core.splitcompat.SplitCompatApplication
```

**原因:**
- R8/ProGuardがコード縮小時にGoogle Play Core等のクラスを見つけられない
- Deferred Componentsなど、Flutterが条件付きで参照するクラスが存在しない

**解決策:**

1. **生成されたルールを確認:**
   ```
   build/app/outputs/mapping/release/missing_rules.txt
   ```

2. **`android/app/proguard-rules.pro`に追加:**
   ```proguard
   # Google Play Core (未使用でも警告抑制)
   -dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
   -dontwarn com.google.android.play.core.splitinstall.**
   -dontwarn com.google.android.play.core.tasks.**
   ```

3. **クリーンビルド:**
   ```bash
   fvm flutter clean
   fvm flutter build appbundle --obfuscate --split-debug-info=build/app/outputs/symbols
   ```

---

## 12. GitHub Actionsによる自動デプロイ

このプロジェクトでは GitHub Actions を使って Android のビルドとデプロイを自動化しています。

### 12.1 ワークフロー概要

| ワークフロー | トリガー | 内容 |
|---|---|---|
| `build-android.yml` | `ci.yml` 成功後（main/develop） | デバッグ APK のビルドと 7 日間の一時保存 |
| `test-distribution.yml` | develop push / 手動 | 署名済み APK → Firebase App Distribution（テスター配信） |
| `deploy-android.yml` | タグ `v*` push / 手動 | リリース AAB → Google Play Store |

### 12.2 `deploy-android.yml` に必要な GitHub Secrets

GitHub リポジトリの **Settings → Secrets and variables → Actions** に以下を登録します。

| シークレット名 | 説明 | 取得方法 |
|---|---|---|
| `KEYSTORE_BASE64` | Keystore ファイル（.jks）を Base64 エンコードしたもの | `base64 -i upload-keystore.jks \| pbcopy` |
| `KEYSTORE_PASSWORD` | Keystore のパスワード | Section 5 でキーストア作成時に設定したパスワード |
| `KEY_PASSWORD` | キーのパスワード | 同上 |
| `KEY_ALIAS` | キーのエイリアス | 通常 `upload`（`keytool` 実行時に `-alias upload` で指定） |
| `PLAY_STORE_SERVICE_ACCOUNT_JSON` | Google Play Console のサービスアカウント JSON | 下記参照 |

#### `PLAY_STORE_SERVICE_ACCOUNT_JSON` の取得手順

1. [Google Cloud Console](https://console.cloud.google.com/) → Google Play Console と**同じプロジェクト**を選択
2. 「APIとサービス」→「認証情報」→「サービスアカウントを作成」（ロールは後で付与するため省略可）
3. 作成したサービスアカウントの「キー」タブ → 「鍵を追加」→「JSON」でダウンロード
4. [Google Play Console](https://play.google.com/console) → 設定 → API アクセス → 対象のサービスアカウントを「アクセス権を付与」（権限: リリースの管理）
5. ダウンロードした JSON ファイルの**中身（テキスト全体）** をシークレットとして登録

### 12.3 `test-distribution.yml` に必要な追加シークレット

Firebase App Distribution へのテスト配信には Section 12.2 のシークレットに加えて以下も必要です。

| シークレット名 | 説明 | 取得方法 |
|---|---|---|
| `FIREBASE_APP_ID_ANDROID` | Firebase Android アプリのアプリ ID | Firebase Console → プロジェクト設定 → 全般 → マイアプリ |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Firebase サービスアカウント JSON | [APP_RELEASE_GUIDE.md - STEP 6](APP_RELEASE_GUIDE.md#step-6-サービスアカウントの作成) 参照 |

### 12.4 配信トラックの選択

`deploy-android.yml` を手動実行する際は `track` パラメータで配信先を選択します。

| トラック | 対象 | 審査 |
|---|---|---|
| `internal` | 内部テスター（最大 100 人） | 不要・即時配信 |
| `alpha` | クローズドテスター | 不要 |
| `beta` | オープンテスター | 不要 |
| `production` | 全ユーザー | Google の審査が必要（通常 1〜3 日） |

### 12.5 リリースフロー

1. `pubspec.yaml` でバージョンを更新（`buildNumber` を必ず増やす）
2. `git commit && git push`
3. `git tag v1.0.1 && git push origin v1.0.1` でタグを push
4. GitHub Actions が自動でリリース AAB をビルド・署名し、Google Play Store にアップロード
