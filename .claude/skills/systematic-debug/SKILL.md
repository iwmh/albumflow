---
name: systematic-debug
description: Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes
---

# Systematic Debugging

## Overview

Random fixes waste time and create new bugs. Quick patches mask underlying issues.

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

## The Iron Law

```
NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST
```

If you haven't completed Phase 1, you cannot propose fixes.

## When to Use

Use for ANY technical issue:
- Test failures
- Bugs in production
- Unexpected behavior
- Performance problems
- Build failures
- Integration issues

**Use this ESPECIALLY when:**
- Under time pressure (emergencies make guessing tempting)
- "Just one quick fix" seems obvious
- You've already tried multiple fixes

## The Four Phases

You MUST complete each phase before proceeding to the next.

### Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read Error Messages Carefully**
   - Don't skip past errors or warnings
   - Read stack traces completely
   - Note line numbers, file paths, error codes

2. **Reproduce Consistently**
   - Can you trigger it reliably?
   - What are the exact steps?

3. **Check Recent Changes**
   - What changed that could cause this?
   - Git diff, recent commits, new dependencies

4. **Gather Evidence in Multi-Component Systems**

   For each component boundary:
   - Log what data enters component
   - Log what data exits component
   - Verify environment/config propagation
   - Check state at each layer

5. **Trace Data Flow**
   - Where does bad value originate?
   - What called this with bad value?
   - Keep tracing up until you find the source
   - Fix at source, not at symptom

### Phase 2: Pattern Analysis

1. Find working examples of similar code in same codebase
2. Compare against reference implementations completely
3. Identify ALL differences, however small
4. Understand all dependencies

### Phase 3: Hypothesis and Testing

1. **Form Single Hypothesis**: "I think X is the root cause because Y"
2. **Test Minimally**: Make SMALLEST possible change to test hypothesis
3. **Verify Before Continuing**: Did it work? Yes → Phase 4. No → New hypothesis
4. Never add more fixes on top without a new hypothesis

### Phase 4: Implementation

1. **Create Failing Test Case** (use `obra-test-driven-development` skill)
2. **Implement Single Fix** — ONE change at a time, no bundled refactoring
3. **Verify Fix** — Test passes? Other tests pass? Issue resolved?
4. **If Fix Doesn't Work**:
   - < 3 attempts: Return to Phase 1 with new information
   - **≥ 3 attempts: STOP and question the architecture**
   - Don't attempt Fix #4 without architectural discussion

## Red Flags - STOP and Follow Process

- "Quick fix for now, investigate later"
- "Just try changing X and see if it works"
- "It's probably X, let me fix that"
- Proposing solutions before tracing data flow
- "One more fix attempt" (when already tried 2+)
- Each fix reveals new problem in different place

**ALL of these mean: STOP. Return to Phase 1.**

## このプロジェクトへの適用

### Flutter/Dart デバッグ手順

```bash
# 1. ログ確認
fvm flutter run --verbose 2>&1 | grep -E "ERROR|WARN|Exception"

# 2. テスト失敗の再現
fvm flutter test test/path/to/failing_test.dart --verbose

# 3. 特定のProviderの状態確認（DevTools）
fvm flutter run --debug
# Flutter DevTools → Provider → 状態確認
```

### Riverpod デバッグ

```dart
// Providerの状態をログ出力
final container = ProviderContainer(
  observers: [
    class _DebugObserver extends ProviderObserver {
      void didUpdateProvider(provider, previous, next, container) {
        debugPrint('[${provider.name}] $previous → $next');
      }
    }(),
  ],
);
```

### ネットワークエラーのデバッグ

```dart
// dioのログInterceptorを一時的に追加
dio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
  logPrint: (o) => debugPrint(o.toString()),
));
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Issue is simple" | Simple issues have root causes too. |
| "Emergency, no time" | Systematic is FASTER than guess-and-check thrashing. |
| "Multiple fixes at once" | Can't isolate what worked. Causes new bugs. |
| "One more fix attempt" (after 2+) | 3+ failures = architectural problem. |

## Quick Reference

| Phase | Key Activities | Success Criteria |
|-------|---------------|------------------|
| **1. Root Cause** | Read errors, reproduce, check changes | Understand WHAT and WHY |
| **2. Pattern** | Find working examples, compare | Identify differences |
| **3. Hypothesis** | Form theory, test minimally | Confirmed or new hypothesis |
| **4. Implementation** | Create test, fix, verify | Bug resolved, tests pass |

Source: [obra/superpowers](https://github.com/obra/superpowers) (120.5K installs)
