#!/bin/bash

# Команда прекращает выполнение скрипта при возникновении ошибки.
set -e

echo "Запуск инициализационного скрипта"

# Создание таблиц источников
for file in /scripts/scripts_to_create_tables_of_sources/*.sql; do
  echo "Выполняем $file"
  psql -v ON_ERROR_STOP=1 -f "$file"
done

# Импорт данных из CSV
echo "Импортируем данные из CSV файлов"
psql -v ON_ERROR_STOP=1 <<EOF
\COPY source1.craft_market_wide FROM '/data/complete_craft_market_wide_20230730.csv' WITH (FORMAT csv, HEADER);

\COPY source2.craft_market_masters_products FROM '/data/complete_craft_market_masters_products_202305071535.csv' WITH (FORMAT csv, HEADER);
\COPY source2.craft_market_orders_customers FROM '/data/complete_craft_market_orders_customers_202305071535.csv' WITH (FORMAT csv, HEADER);

\COPY source3.craft_market_craftsmans FROM '/data/complete_craft_market_craftsmans_202305071534.csv' WITH (FORMAT csv, HEADER);
\COPY source3.craft_market_customers FROM '/data/complete_craft_market_customers_202305071535.csv' WITH (FORMAT csv, HEADER);
\COPY source3.craft_market_orders FROM '/data/complete_craft_market_orders_202305071535.csv' WITH (FORMAT csv, HEADER);
EOF

# Создание таблиц DWH и витрин
for file in /scripts/scripts_to_create_tables_DWH_showcase/*.sql; do
  echo "Выполняем $file"
  psql -v ON_ERROR_STOP=1 -f "$file"
done

echo "Инициализация базы данных завершена"