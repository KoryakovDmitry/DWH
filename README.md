# DWH
Практическое задание для магистров

# Идея: Маркетплейс товаров ручного производства из разных стран.

Вы работаете в компании, которая создает приложение маркетплейс для эксклюзивных товаров ручной работы мастеров. Мастера, которые изготавливают свои товары вручную выкладывают их на продажу на различных сайтах, у каждого из которых свой бэкенд со своей моделью данных в БД. Ваша компания покупает эти сайты, но не меняет у них домены, а значит, мастера всё ещё могут туда выкладывать свои товары, а покупатели делать там покупки. Нужно организовать корпоративное хранилище данных (DWH) на основе данных из трех источников и построить конечную витрину данных со статистикой о продажах.

Общая схема задания
![Сквозной кейс схема](https://github.com/user-attachments/assets/3d057216-7b96-4bca-a75e-83f3ea5d9696)

### Что было сделано:
1. Вместо `Docker Desktop` я использую `colima` для Mac OS

2. Вместо `DBeaver Community` я использую `Pgadmin` (см. `docker-compose.yml`)

3. Написал `Dockerfile.postgres` и `docker-compose.yml`

4-5-6. Вместо ручной загрузки в базу данных, я создал `bash` скрипт, который всё инициализирует `scripts/00_init_db.sh`. 
   Обновил изначальные скрипты. Добавил `CREATE SCHEMA dwh;`, которого не было. И дополнительные минорные апдейты.

7. - [x] Запустите Spark в Docker, чтобы он имел доступ к PostgreSQL в docker (нужно настроить сетевую связанность между ними)
   - https://hub.docker.com/r/jupyter/all-spark-notebook
   - https://stackoverflow.com/questions/37694987/connecting-to-postgresql-in-a-docker-container-from-outside
8. - [x] Напишите код на Spark, который будет заполнять сначала таблицы измерений и фактов в DWH.
   - https://spark.apache.org/docs/latest/sql-getting-started.html
   - https://spark.apache.org/docs/3.5.1/sql-data-sources-jdbc.html
9. Затем напишите код на Spark, который заполнит таблицу витрины данных из данных таблиц измерений и фактов в DWH. Напишите код инкрементальным, чтобы можно было забирать только измененные данные на источниках.
   - https://spark.apache.org/docs/latest/sql-getting-started.html
   - Обратите внимание на комментарии к колонкам в скрипте DDL витрины данных dwh.craftsman_report_datamart. Там написано, что должно содержаться в этих колонках.

# Как сдавать задание:

Минимальные требования для сдачи практической работы:
1. Должен быть ваш репозиторий с кодом на Apache Spark - его надо прислать в тг @neltari.
2. PostgreSQL и Spark должны запускаться в Docker.
3. В Readme репозитория должна быть инструкция, как запускать скрипты для проверки.
4. Должна быть реализована инкрементальная загрузка


# Инструкции по запуску

0. If you need to do everything from scratch then down the volumes: `docker-compose down -v`

1. docker-compose --env-file .env.example up -d --build 
2. Goto http://localhost:8897/lab
3. Set token, check logs from `docker-compose logs -f jupyter`. You can found token, for example, `lab?token=7ce9baaba2d1b808a2beed30030084ea7c1111e2ce010dcf`
4. Run Jupyter cells