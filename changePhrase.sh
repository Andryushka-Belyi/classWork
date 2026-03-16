for file in *.md; do
    # Проверяем, что файл существует (на случай, если нет ни одного .md файла)
    [ -e "$file" ] || continue

    # Проверяем, не содержит ли файл уже нужную фразу
    if grep -q "Ваша фраза" "$file"; then
        echo "Пропускаем $file: фраза уже есть."
        continue
    fi

    # Запрашиваем подтверждение
    read -p "Добавить фразу в '$file'? (y/N) " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        echo "Ваша фраза" >> "$file"
        echo "✓ Фраза добавлена в $file"
    else
        echo "✗ Пропущен $file"
    fi
done
