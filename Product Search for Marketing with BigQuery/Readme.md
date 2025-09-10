```
bq load --source_format=CSV --skip_leading_rows=1 --autodetect [your-dataset].products_information gs://[your-projectID]-bucket/products.csv
```
```
bq query --use_legacy_sql=false 'CREATE SEARCH INDEX product_search_index ON [your-dataset].products_information(ALL COLUMNS)'
```
```
bq query --use_legacy_sql=false 'SELECT * FROM [your-dataset].products_information WHERE SEARCH(products_information, "22 oz Water Bottle")'
```
*note:
ubah projectID dan nama dataset sesuai yang ada di lab masing-masing
