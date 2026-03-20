# AGENTS.md

## コミュニケーション

- 日本語で返答する

## ワークフロー

- Swiftのコードを変更したら `make lint && make build-debug-develop` を実行する
- `main` ブランチにいる場合はfeatureブランチを切る
- Conventional Commitsに従ってコミットメッセージを書く
- コミットしたらプッシュする
- PRが作成されていない場合、コミット者をアサインしてDraftで作成する
