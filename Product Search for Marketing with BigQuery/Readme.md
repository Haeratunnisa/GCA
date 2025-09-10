# Query Execution
-

You can execute queries in two different ways 
Choose one of the following methods:
-
- ✍️ **Manual Queries**  
-
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

- 🤖 **Generated Queries** 
```
curl -LO raw.githubusercontent.com/Haeratunnisa/GCA/main/Product%20Search%20for%20Marketing%20with%20BigQuery/40643.sh
sudo chmod +x 40643.sh
./40643.sh
```
```
bq query --use_legacy_sql=false 'SELECT * FROM products.products_information WHERE SEARCH(products_information, "22 oz Water Bottle")'

