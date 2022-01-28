-- SELECT – retrieve all columns from a table example
select * from production.brands 


-- SELECT – retrieve some columns of a table example
SELECT first_name,last_name,email FROM sales.customers;


-- ORDER BY - Sort a result set by multiple columns and different orders
-- The following statement sorts the customers by the city in descending order and the sort the sorted result set by the first name in ascending order.
SELECT city,first_name,last_name FROM  sales.customers ORDER BY city DESC,first_name ASC;


-- OFFSET FETCH - To skip the first 10 products and select the next 10 products, you use both OFFSET and FETCH 
SELECT product_name,list_price FROM production.products ORDER BY list_price,product_name OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;


--SELECT TOP - Using TOP with a constant value
SELECT TOP 10
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;


--SELECT TOP BY PERCENTAGE - to return a percentage of rows
SELECT TOP 1 PERCENT
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;


--SELECT TOP - to include rows that match the values in the last row
SELECT TOP 3 WITH TIES
    product_name, 
    list_price
FROM
    production.products
ORDER BY 
    list_price DESC;


-- DISTINCT -  distinct city and state of all customers(removing the duplicates)
SELECT DISTINCT
    city,
    state
FROM
    sales.customers


-- WHERE - Finding rows that meet two conditions(specify a search condition to filter rows returned by the FROM clause)
SELECT
    product_id,
    product_name,
    category_id,
    model_year,
    list_price
FROM
    production.products
WHERE
    category_id = 1 AND model_year = 2018
ORDER BY
    list_price DESC;


-- AND – combine two Boolean expressions and return true if all expressions are true.
-- (finds the products where the category identification number is one and the list price is greater than 400)
SELECT
    *
FROM
    production.products
WHERE
    category_id = 1
AND list_price > 400
ORDER BY
    list_price DESC;


-- OR–  combine two Boolean expressions and return true if either of conditions is true.
-- finds the products whose list price is less than 200 or greater than 6,000
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price < 200
OR list_price > 6000
ORDER BY
    list_price;


-- IN – check whether a value matches any value in a list or a subquery.
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price IN (89.99, 109.99, 159.99)
ORDER BY
    list_price;


-- BETWEEN – test if a value is between a range of values.
SELECT
    product_id,
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price BETWEEN 149.99 AND 199.99
ORDER BY
    list_price;


-- LIKE  –  check if a character string matches a specified pattern.
-- The following example finds the customers whose last name starts with the letter z
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers
WHERE
    last_name LIKE 'z%'
ORDER BY
    first_name;


-- COLUMN ALIASES - To assign a column or an expression a temporary name during the query execution, you use a column alias.
SELECT
    first_name + ' ' + last_name AS 'Full Name'
FROM
    sales.customers
ORDER BY
    first_name;


-- COLUMN ALIASES 
-- how to assign an alias to a column( without AS keyword)
SELECT
    category_name 'Product Category'
FROM
    production.categories;


-- TABLE ALIASES - to improve the readability of a query
-- A table can be given an alias which is known as correlation name or range variable.
SELECT
    c.customer_id,
    first_name,
    last_name,
    order_id
FROM
    sales.customers c
INNER JOIN sales.orders o ON o.customer_id = c.customer_id;


-- INNER JOIN - select rows from a table that have matching rows in another table
-- produces a data set that includes rows from the left table, matching rows from the right table.
SELECT
    product_name,
    category_name,
    list_price
FROM
    production.products p
INNER JOIN production.categories c 
    ON c.category_id = p.category_id
ORDER BY
    product_name DESC;


-- LEFT JOIN -return all rows from the left table and matching rows from the right table. 
-- In case the right table does not have the matching rows, use null values for the column values from the right table.
SELECT
    product_name,
    order_id
FROM
    production.products p
LEFT JOIN sales.order_items o ON o.product_id = p.product_id
ORDER BY
    order_id;


-- RIGHT JOIN -  starts selecting data from the right table and matching it with the rows from the left table. 
-- If a row in the right table does not have any matching rows from the left table, 
-- the column of the left table in the result set will have nulls.
SELECT
    product_name,
    order_id
FROM
    sales.order_items o
    RIGHT JOIN production.products p 
        ON o.product_id = p.product_id
WHERE 
    order_id IS NULL
ORDER BY
    product_name;


-- FULL OUTER JOIN – return matching rows from both left and right tables, and rows from each side if no matching rows exist.
SELECT
    product_name,
    order_id
FROM
    sales.order_items o
    FULL JOIN production.products p 
        ON o.product_id = p.product_id


-- CROSS JOIN – join multiple unrelated tables and create Cartesian products of rows in the joined tables.
SELECT
    product_id,
    product_name,
    store_id,
    0 AS quantity
FROM
    production.products
CROSS JOIN sales.stores
ORDER BY
    product_name,
    store_id;


-- Self join – show you how to use the self-join to query hierarchical data and compare rows within the same table.
SELECT
    e.first_name + ' ' + e.last_name employee,
    m.first_name + ' ' + m.last_name manager
FROM
    sales.staffs e
LEFT JOIN sales.staffs m ON m.staff_id = e.manager_id
ORDER BY
    manager;











