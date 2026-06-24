# AlbumFlow for Spotify アプリ公開ガイド

プラットフォーム別の詳細ガイド:
- [Android - Google Play Store公開](APP_RELEASE_GUIDE_ANDROID.md)
- [iOS - App Store公開](APP_RELEASE_GUIDE_IOS.md)

---

## 目次

1. [事前準備](#1-事前準備)
2. [GitHub Actionsによる自動化](#2-github-actionsによる自動化)
3. [Firebase App Distribution によるテスト配信](#3-firebase-app-distribution-によるテスト配信)
4. [トラブルシューティング](#4-トラブルシューティング)

---

## 1. 事前準備

### 1.1 開発者アカウントの作成

#### Google Play Console（Android）

- [Google Play Console](https://play.google.com/console) にアクセスし、Googleアカウントで登録
- 登録料: **$25（一度のみ）**
- 開発者名・連絡先メールアドレス・電話番号・住所の登録が必要

#### Apple Developer Program（iOS）

- [Apple Developer Program](https://developer.apple.com/programs/) にアクセスし、Apple IDで登録
- 登録料: **年間 $99（約15,000円）**
- 二要素認証の有効化が必須
- 組織として登録する場合は D-U-N-S 番号が必要

### 1.2 アプリアイコンの準備

[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons) パッケージを使用して各サイズのアイコンを一括生成します。元となる **1024×1024 px の PNG 画像**を用意し、`pubspec.yaml` に設定後 `dart run flutter_launcher_icons` を実行します。

### 1.3 スプラッシュスクリーンの設定

[flutter_native_splash](https://pub.dev/packages/flutter_native_splash) パッケージを使用します。`pubspec.yaml` に背景色・画像などを設定後 `dart run flutter_native_splash:create` を実行します。

### 1.4 アプリのバージョン管理

`pubspec.yaml` の `version` フィールドで一元管理します。

- 形式: `major.minor.patch+buildNumber`（例: `1.0.0+1`）
- `buildNumber`（`+` 以降の数字）はストアへのアップロードごとに**必ず増やす**
- 一度使ったビルド番号は再利用できない

---

## 2. GitHub Actionsによる自動化

### 2.1 ワークフロー構成

| ファイル | トリガー | 役割 |
|---|---|---|
| `ci.yml` | PR・push（main/develop） | 静的解析 + ユニットテスト |
| `build-android.yml` | `ci.yml` 成功後（main/develop） | Android デバッグ APK ビルド（アーティファクト保存のみ） |
| `build-ios.yml` | `ci.yml` 成功後（main/develop） | iOS AdHoc IPA ビルド → Firebase App Distribution |
| `test-distribution.yml` | develop push / 手動 | Android APK + iOS IPA → Firebase App Distribution（テスター一括配信） |
| `deploy-android.yml` | タグ `v*` push / 手動 | Android リリースビルド → Google Play Store |
| `deploy-ios.yml` | 手動 | iOS リリースビルド → TestFlight / App Store |

### 2.2 GitHub Secrets の設定

各ワークフローには GitHub Secrets への登録が必要です。必要なシークレット一覧と取得方法は各プラットフォームのガイドを参照してください。

- **Android**: [APP_RELEASE_GUIDE_ANDROID.md - Section 12](APP_RELEASE_GUIDE_ANDROID.md#12-github-actionsによる自動デプロイ)
- **iOS**: [APP_RELEASE_GUIDE_IOS.md - Section 4.5・4.6](APP_RELEASE_GUIDE_IOS.md#45-build-ios-yml-firebase-app-distribution-に必要な-github-secrets)

---

## 3. Firebase App Distribution によるテスト配信

Firebase の初期セットアップは Android・iOS で共通です。

### STEP 1: Firebase プロジェクトの作成

1. [Firebase Console](https://console.firebase.google.com/) を開く
2. 「プロジェクトを追加」→ プロジェクト名を入力（例: `albumflow`）
3. Google アナリティクスは任意
4. 「プロジェクトを作成」

### STEP 2: Android アプリを登録

1. プロジェクトホームで Android アイコンをクリック
2. パッケージ名 `com.iwmh.albumflow` を入力 → 「アプリを登録」
3. プロジェクト設定（歯車）→ 全般 → マイアプリ内の **アプリ ID** をメモ（形式: `1:xxx:android:xxx`）

### STEP 3: iOS アプリを登録

1. プロジェクトホームで Apple アイコンをクリック
2. バンドル ID `com.iwmh.albumflow` を入力 → 「アプリを登録」
3. プロジェクト設定 → 全般 → マイアプリ内の **アプリ ID** をメモ（形式: `1:xxx:ios:xxx`）

> **注意:** Firebase に「Flutter アプリ」という種類は存在しません。Android と iOS をそれぞれ別々に登録します。

### STEP 4: App Distribution を有効化

Firebase Console の「リリースと監視」→「App Distribution」から Android・iOS それぞれで「使ってみる」をクリックして有効化します。

### STEP 5: テスターグループを作成

App Distribution の「テスター & グループ」タブで `testers` グループを作成し、テスターのメールアドレスを登録します（ワークフローの `groups: testers` と名前を一致させること）。

### STEP 6: サービスアカウントの作成

GitHub Actions から Firebase にアップロードするための認証情報です。

1. [Google Cloud Console](https://console.cloud.google.com/) → Firebase と同じプロジェクトを選択
2. 「IAM と管理」→「サービスアカウント」→「サービスアカウントを作成」
3. ロール: **Firebase App Distribution 管理者** を付与
4. 「キー」タブ → 「鍵を追加」→ JSON でダウンロード
5. ダウンロードした JSON の**テキスト全体**をシークレット `FIREBASE_SERVICE_ACCOUNT_JSON` として GitHub に登録

---

## 4. トラブルシューティング

### 4.1 シークレット関連のエラー

- シークレット名のスペルミスが最多原因です。ワークフロー内の `secrets.XXX` とリポジトリの Secrets 名が完全一致しているか確認してください
- Base64 エンコード時に `echo -n`（改行なし）を付けていないと認証が失敗します

### 4.2 ビルドタイムアウト

macOS ランナーは Windows/Linux より起動が遅いためタイムアウトが発生しやすいです。`subosito/flutter-action` の `cache: true` を有効にすることで Flutter SDK のダウンロード時間を短縮できます。

### 4.3 プラットフォーム別トラブルシューティング

- **Android**: [APP_RELEASE_GUIDE_ANDROID.md - Section 11](APP_RELEASE_GUIDE_ANDROID.md#11-トラブルシューティング)
- **iOS**: [APP_RELEASE_GUIDE_IOS.md - Section 8](APP_RELEASE_GUIDE_IOS.md#8-トラブルシューティング)

---

## 更新履歴

| 日付 | 内容 |
|------|------|
| 2024-12-22 | 初版作成 |
| 2026-02-15 | Flutter公式ドキュメントに基づき大幅更新 |
| 2026-06-06 | ドキュメント分割：共通部分、Android版、iOS版に分割 |
| 2026-06-07 | 各プラットフォーム固有の記載をプラットフォームガイドに移動、コード例を削除し概要ガイドとして整理 |

---

このガイドに関する質問や改善提案があれば、Issue を作成してください。
