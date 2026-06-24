---
name: improve-architecture
description: コードベースのアーキテクチャ改善。浅いモジュールを深いモジュールに変えるリファクタリング機会を探す。
---

# アーキテクチャ改善

## 概要

ServiceがHTTP・ビジネスロジック・ストレージを混在させている現状を、責務が明確に分離された3層構造に移行する。「深いモジュール」化によってテスト容易性とAI可読性を高める。

## 用語

- **深いモジュール** — 小さなインターフェースの裏に多くの振る舞いがある（高レバレッジ）
- **浅いモジュール** — インターフェースが実装とほぼ同じ複雑さ（パススルーに近い）
- **削除テスト** — そのモジュールを削除したとき複雑さがどこへ行くか？N個の呼び出し元に分散するなら稼いでいた証拠
- **継ぎ目（Seam）** — インターフェースが存在する場所。テストでの差し替えポイント

## プロセス

### 1. 探索

コードベースを歩いて摩擦を感じる箇所をメモする:
- 一つの概念を理解するために複数の小さなモジュールを行き来する
- モジュールが浅い（インターフェースが実装と同程度に複雑）
- 密結合なモジュールが継ぎ目を越えて漏れている
- テストが困難か、現在のインターフェースを通じてテストできない

疑わしい箇所に**削除テスト**を適用する。

### 2. 候補を提示

各候補について:
- **Files**: 関係するファイル/モジュール
- **Problem**: 現在のアーキテクチャが摩擦を生む理由
- **Solution**: 何が変わるかの説明
- **Benefits**: locality（変更の局所化）とleverage（レバレッジ）の観点で
- **Before / After**: 浅さと深まりの対比
- **推奨強度**: `Strong`、`Worth exploring`、`Speculative`

最後に**Top recommendation**を示す。インターフェース設計は提案しない — ユーザーに「どれを探索しますか？」と聞く。

### 3. 設計討議

ユーザーが候補を選んだら:
- 制約と依存関係
- 深まったモジュールの形
- 継ぎ目の裏に何が来るか
- どのテストが生き残るか

## アーキテクチャ層

```
lib/features/<feature>/
├── models/          # ドメインモデル（freezed）
├── repositories/    # データ取得の抽象化（インターフェース + 実装）
├── usecases/        # 複数Repositoryをまたぐビジネスロジック（任意）
├── providers/       # Riverpodプロバイダー（UI ↔ Repository橋渡し）
├── screens/         # 画面Widget
└── widgets/         # 再利用可能なWidget
```

## 依存の方向

```
UI（Widget）
    ↓ watches/reads
Provider（Riverpod）
    ↓ uses
Repository（抽象）← テストでモック注入
    ↓ implements
Repository実装（HTTP）
    ↓ uses
SpotifyHttpClient（dio）
```

**外側が内側に依存する。逆は禁止。**

## Repositoryパターン例

```dart
// 抽象インターフェース（テスト用モックの起点）
abstract interface class PlaylistRepository {
  Future<List<Playlist>> getPlaylists(String accessToken);
  Future<List<Track>> getTracks(String accessToken, String playlistId);
}

// Riverpodでの提供
@riverpod
PlaylistRepository playlistRepository(Ref ref) {
  return SpotifyPlaylistRepository(ref.read(spotifyHttpClientProvider));
}

// テストでのモック
final container = ProviderContainer(overrides: [
  playlistRepositoryProvider.overrideWithValue(MockPlaylistRepository()),
]);
```

## このプロジェクトの既知の浅いモジュール

### Strong: ServiceからRepositoryへの移行

| 旧: Service | 新: Repository |
|---|---|
| `AuthService` | `AuthRepository` + `SecureStorageAuthRepository` |
| `PlaylistService` | `PlaylistRepository` + `SpotifyPlaylistRepository` |
| HTTP呼び出し | `SpotifyHttpClient`（dio）に集約 |

**削除テスト**: `PlaylistService`を削除すると複雑さは各Provider/Screenに分散する → 稼いでいない

### Strong: HTTP共通化

`AuthService` + `PlaylistService`のHTTP → `SpotifyHttpClient`（dio + Interceptor）
- **Leverage**: 認証・リトライ・ログが1箇所で管理される

## 禁止パターン

- ❌ ProviderからHTTPを直接呼ぶ
- ❌ WidgetからServiceを直接呼ぶ
- ❌ Repositoryがwidgetのcontextを参照する
- ❌ 具体実装クラスをテストで直接インスタンス化する
