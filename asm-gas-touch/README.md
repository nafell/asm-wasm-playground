# asm-gas-touch

x86-64 Linux向けGAS (GNU Assembler) アセンブリ開発環境

## 前提環境

| 項目 | 要件 |
|------|------|
| OS | Linux (x86-64) |
| アセンブラ | GNU Assembler (gas) |
| リンカ | GNU ld |
| ビルドツール | GNU Make |

### 動作確認済み環境

- Ubuntu (gcc 13.3.0, GNU Binutils 2.42)

### 環境確認コマンド

```bash
uname -m          # x86_64 であること
as --version      # GNU assembler
ld --version      # GNU ld
```

## セットアップ

特別なセットアップは不要です。標準的なLinux開発環境があれば動作します。

```bash
# Ubuntu/Debian の場合
sudo apt install build-essential
```

## プロジェクト構成

```
asm-gas-touch/
├── README.md     # このファイル
├── Makefile      # ビルド設定
├── .gitignore    # ビルド生成物を除外
└── hello.s       # サンプルプログラム
```

## ビルドと実行

```bash
make          # 全ての .s ファイルをビルド
make run      # hello を実行
make clean    # ビルド生成物を削除
make disasm   # 逆アセンブル表示
```

## 新しいプログラムの追加

1. `*.s` ファイルを作成
2. `make` を実行

Makefileは自動的に全ての `.s` ファイルを検出してビルドします。

## アセンブリ構文

AT&T構文 (GAS標準) を使用しています。

```asm
# レジスタには % プレフィックス
movq $1, %rax

# 即値には $ プレフィックス
movq $60, %rax

# オペランド順序: src, dst
movq %rax, %rbx    # rax -> rbx
```

## x86-64 Linux システムコール

| syscall | rax | rdi | rsi | rdx |
|---------|-----|-----|-----|-----|
| write   | 1   | fd  | buf | count |
| exit    | 60  | status | - | - |

参考: https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
