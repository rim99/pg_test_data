# PG test data

The source of data set is [test_db](https://github.com/datacharmer/test_db), which is for MySQL/MariaDB originally.

## How to use

The data sets are saved in CSV files, which are archived in `data.zip`. Please extract those files under folder `.data`. Then execute cmd

```
psql < create_tables.sql
```

It will create tables & views in schema `employees`.

## LICENSE

MIT
