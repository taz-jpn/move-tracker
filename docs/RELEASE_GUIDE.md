# MoveTracker リリースビルドガイド

## 前提条件

- Flutter SDK がインストールされていること
- Android SDK がインストールされていること
- JDK 17 以上がインストールされていること

---

## Step 1: Upload Key の作成（初回のみ）

```bash
keytool -genkey -v \
  -keystore ~/movetracker.keystore \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias movetracker
```

質問に回答してパスワードを設定します。

⚠️ **重要**: keystore ファイルとパスワードは紛失不可！

---

## Step 2: key.properties の作成

`android/key.properties` を作成:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=movetracker
storeFile=/Users/あなた/movetracker.keystore
```

※ `android/key.properties.example` をコピーして編集

---

## Step 3: リリースビルド

```bash
# 1. 依存関係を取得
flutter pub get

# 2. クリーンビルド（推奨）
flutter clean

# 3. AABをビルド
flutter build appbundle --release
```

### 出力ファイル

```
build/app/outputs/bundle/release/app-release.aab
```

---

## Step 4: ビルドの確認

```bash
# ファイルサイズ確認
ls -lh build/app/outputs/bundle/release/app-release.aab

# bundletool でローカルテスト（オプション）
# bundletool build-apks --bundle=app-release.aab --output=app.apks
```

---

## Step 5: Google Play Console にアップロード

1. [Google Play Console](https://play.google.com/console) にログイン
2. 「アプリを作成」または既存アプリを選択
3. 「リリース」→「製品版」→「新しいリリースを作成」
4. `app-release.aab` をアップロード
5. リリースノートを入力
6. 審査に提出

---

## チェックリスト

### ビルド前

- [ ] バージョン番号を確認 (`pubspec.yaml` の `version:`)
- [ ] key.properties が正しく設定されている
- [ ] keystoreファイルが存在する

### アップロード前

- [ ] プライバシーポリシーのURLを用意
- [ ] スクリーンショットを撮影
- [ ] ストア説明文を準備

### Google Play Console

- [ ] アプリ情報を入力
- [ ] コンテンツレーティング質問に回答
- [ ] ターゲットユーザーを設定
- [ ] プライバシーポリシーURLを設定

---

## トラブルシューティング

### ビルドエラー: 署名関連

```
key.properties が見つからない、または設定が間違っている可能性
→ android/key.properties を確認
```

### ビルドエラー: Gradle

```bash
# Gradleキャッシュをクリア
cd android && ./gradlew clean && cd ..
flutter clean
flutter pub get
```

### アップロードエラー: バージョンコード

```
versionCode が既存リリースより大きい必要がある
→ pubspec.yaml の version: 1.0.0+1 の +1 を +2 に増やす
```

---

## 関連ファイル

| ファイル | 説明 |
|----------|------|
| `pubspec.yaml` | バージョン番号 |
| `android/key.properties` | 署名設定（Git管理外） |
| `android/key.properties.example` | 署名設定テンプレート |
| `android/app/build.gradle.kts` | ビルド設定 |
| `docs/privacy/` | プライバシーポリシー |
| `docs/store/` | ストア掲載情報 |
| `resources/` | アイコン、グラフィック |

---

## 次回リリース時

```bash
# 1. pubspec.yaml のバージョンを更新
#    version: 1.0.1+2

# 2. ビルド
flutter build appbundle --release

# 3. アップロード
```
