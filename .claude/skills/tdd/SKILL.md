---
name: tdd
description: テスト駆動開発（Red-Green-Refactor）。機能実装・バグ修正の前にテストを書く。
---

# Test-Driven Development (TDD)

## 鉄則

```
NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST
```

テストを書く前にコードを書いた場合は削除してやり直す。例外なし。

## 思想

**良いテスト**: パブリックインターフェースを通じて振る舞いを検証する。内部実装には依存しない。リファクタリングしてもテストは壊れない。

**悪いテスト**: 内部実装に結合している。内部コラボレータをモックする。振る舞いが変わっていないのにリファクタリングで壊れる。

## アンチパターン: 水平スライス

**全テスト → 全実装 の順番で書かない（水平スライス）。**

```
NG（水平）: test1, test2, test3 → impl1, impl2, impl3
OK（垂直）: test1→impl1, test2→impl2, test3→impl3
```

水平スライスは想像上の振る舞いをテストするため、実際の変更に感度がない。

## Red-Green-Refactor

### RED - 失敗するテストを書く
```bash
fvm flutter test path/to/test.dart
```

確認事項:
- テストが失敗する（エラーではなく）
- 期待通りの失敗メッセージ
- 機能が存在しないから失敗している（タイポではない）

テストが通る場合: 既存の振る舞いをテストしている → テストを修正する

### GREEN - 通すための最小限のコード

テストを通すだけのコード。先読みして機能を追加しない。

```bash
fvm flutter test path/to/test.dart
```

### REFACTOR - グリーン後のみ整理

- 重複の除去
- 変数名の改善
- ヘルパーの抽出

テストをグリーンに保ったまま行う。新しい振る舞いを追加しない。

## Dart/Flutter 実装例

```dart
// RED: まずリポジトリのパブリックインターフェースをテストする
test('プレイリストを取得できる', () async {
  final container = ProviderContainer(overrides: [
    playlistRepositoryProvider.overrideWithValue(
      InMemoryPlaylistRepository([
        Playlist(id: '1', name: 'My Playlist'),
      ]),
    ),
  ]);

  final playlists = await container.read(playlistsProvider.future);

  expect(playlists, hasLength(1));
  expect(playlists.first.name, 'My Playlist');
});

// 内部実装はモックしない — Repository interfaceをテストする
```

## TDDサイクル（このプロジェクト用）

```bash
# 1. テストを書く
# test/features/<feature>/<class>_test.dart

# 2. テストが失敗することを確認
fvm flutter test test/features/<feature>/<class>_test.dart

# 3. 最小限の実装
# lib/features/<feature>/...

# 4. テストが通ることを確認
fvm flutter test test/features/<feature>/<class>_test.dart

# 5. リファクタリング後も通ることを確認
fvm flutter test
```

## 完了チェックリスト

- [ ] テストが振る舞いを記述し、実装ではない
- [ ] テストがパブリックインターフェースのみを使用
- [ ] テストは内部リファクタリングを生き残れる
- [ ] 各関数/メソッドにテストがある
- [ ] 失敗を確認してから実装した
- [ ] 最小限のコードで通した
- [ ] すべてのテストが通る
- [ ] エッジケースとエラーがカバーされている

## よくある言い訳

| 言い訳 | 現実 |
|--------|------|
| 「シンプルすぎてテスト不要」 | シンプルなコードも壊れる。テストは30秒 |
| 「後でテストする」 | 後でテストが通っても何も証明しない |
| 「手動テスト済み」 | 記録がない。再実行できない |
| 「TDDは遅い」 | デバッグより速い |
