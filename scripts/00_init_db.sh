#!/bin/bash

# Команда прекращает выполнение скрипта при возникновении ошибки.
set -e

echo "Запуск инициализационного скрипта"

# Создание таблиц источников
for file in /docker-entrypoint-initdb.d/scripts_to_create_tables_of_sources/*.sql; do
  echo "Выполняем $file"
  psql -v ON_ERROR_STOP=1 -f "$file"
done

# Импорт данных из CSV
echo "Импортируем данные из CSV файлов"
psql -v ON_ERROR_STOP=1 <<EOF
\COPY dwh_source_1 FROM '/docker-entrypoint-initdb.d/data/source_1.csv' WITH (FORMAT csv, HEADER);
\COPY dwh_source_2 FROM '/docker-entrypoint-initdb.d/data/source_2.csv' WITH (FORMAT csv, HEADER);
\COPY dwh_source_3 FROM '/docker-entrypoint-initdb.d/data/source_3.csv' WITH (FORMAT csv, HEADER);
EOF

# Создание таблиц DWH и витрин
for file in /docker-entrypoint-initdb.d/scripts_to_create_tables_DWH_showcase/*.sql; do
  echo "Выполняем $file"
  psql -v ON_ERROR_STOP=1 -f "$file"
done

echo "Инициализация базы данных завершена"