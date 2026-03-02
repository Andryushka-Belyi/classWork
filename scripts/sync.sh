#!/bin/bash

set -e

SOURCE_REPO="$1"
TARGET_REPO="$2"

echo "🔍 Проверка путей..."

if [ -z "$SOURCE_REPO" ] || [ -z "$TARGET_REPO" ]; then
  echo "❌ Укажи два пути: source и target"
  exit 1
fi

if [ ! -d "$SOURCE_REPO" ] || [ ! -d "$TARGET_REPO" ]; then
  echo "❌ Один из путей не существует"
  exit 1
fi

if [ "$SOURCE_REPO" == "$TARGET_REPO" ]; then
  echo "❌ Пути совпадают"
  exit 1
fi

echo "📥 git pull..."
cd "$SOURCE_REPO"
git pull

echo "🧹 Очистка target (кроме .git)..."

find "$TARGET_REPO" -mindepth 1 ! -name ".git" -exec rm -rf {} +

echo "📂 Копирование..."

cp -R "$SOURCE_REPO"/. "$TARGET_REPO"

echo "🧽 Удаление .git из target (если случайно скопировался)..."
rm -rf "$TARGET_REPO/.git"

echo "✅ Синхронизация завершена"

read -p "🚀 Сделать git push? (y/n): " PUSH

if [ "$PUSH" == "y" ]; then
  cd "$TARGET_REPO"
  git add .
  git commit -m "Full sync overwrite"
  git push
fi

echo "🎉 Готово"