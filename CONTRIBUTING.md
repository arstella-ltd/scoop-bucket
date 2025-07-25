# Contributing to Arstella Scoop Bucket

このドキュメントでは、Arstella Scoop Bucketへの貢献方法とメンテナンス手順について説明します。

## マニフェストのテスト

### ローカルでのテスト方法

1. PowerShellを開き、Scoop bucketディレクトリに移動します：
   ```powershell
   cd path\to\scoop-bucket
   ```

2. テストスクリプトを実行します：
   ```powershell
   # 全マニフェストをテスト
   .\bin\test.ps1
   
   # 特定のマニフェストをテスト
   .\bin\test.ps1 -AppName redmine
   ```

3. マニフェストの妥当性を手動で確認：
   ```powershell
   # JSONの構文チェック
   scoop config debug $true
   scoop install .\bucket\redmine.json
   ```

### インストールテスト

1. ローカルバケットを追加：
   ```powershell
   scoop bucket add test-arstella "path\to\scoop-bucket"
   ```

2. アプリケーションをインストール：
   ```powershell
   scoop install test-arstella/redmine
   ```

3. 動作確認：
   ```powershell
   redmine --version
   redmine --help
   ```

4. アンインストール：
   ```powershell
   scoop uninstall redmine
   scoop bucket rm test-arstella
   ```

## 新しいバージョンへの更新

### 自動更新（推奨）

GitHub Actionsの`excavator.yml`が6時間ごとに自動でバージョンを確認し、更新します。

### 手動更新

1. 新しいバージョンのハッシュ値を計算：
   ```powershell
   # URLからハッシュを計算
   scoop hash https://github.com/arstella-ltd/RedmineCLI/releases/download/vX.Y.Z/redmine-cli-win-x64.zip
   ```

2. マニフェストを更新：
   - `version`フィールドを新しいバージョンに変更
   - `architecture.64bit.hash`を新しいハッシュ値に更新
   - URLのバージョン番号を更新

3. 変更をコミット：
   ```bash
   git add bucket/redmine.json
   git commit -m "Update RedmineCLI to version X.Y.Z"
   git push
   ```

## マニフェストの構造

### 必須フィールド

- `version`: アプリケーションのバージョン
- `description`: アプリケーションの説明
- `homepage`: 公式サイトまたはGitHubリポジトリ
- `license`: ライセンス情報（SPDX識別子推奨）
- `architecture`: アーキテクチャ別のダウンロード情報
  - `url`: ダウンロードURL
  - `hash`: SHA256ハッシュ値
- `bin`: 実行ファイルのパス

### オプションフィールド

- `notes`: インストール後に表示されるメッセージ
- `checkver`: バージョンチェックの設定
- `autoupdate`: 自動更新の設定
- `extract_dir`: 展開ディレクトリ（ZIPファイル内にサブディレクトリがある場合）

## トラブルシューティング

### よくある問題

1. **ハッシュ値の不一致**
   ```
   エラー: Hash check failed!
   ```
   解決方法：正しいハッシュ値を再計算して更新

2. **ダウンロードエラー**
   ```
   エラー: Download failed
   ```
   解決方法：URLが正しいか、リリースが公開されているか確認

3. **展開エラー**
   ```
   エラー: Extract failed
   ```
   解決方法：`extract_dir`の設定を確認、またはZIPファイルの構造を確認

## Pull Requestのガイドライン

1. 1つのPRにつき1つのアプリケーション更新
2. コミットメッセージは `Update [app] to version X.Y.Z` の形式
3. テストスクリプトが成功することを確認
4. 新しいアプリケーションを追加する場合は、READMEも更新

## セキュリティ

- ダウンロードURLは公式リリースページのものを使用
- ハッシュ値は必ず検証
- 不審なバイナリや未検証のソースからのアプリケーションは追加しない