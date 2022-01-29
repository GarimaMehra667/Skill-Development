-- GROUP BY – group the query result based on the values in a specified list of column expressions.
-- the following query returns the number of orders placed by the customer by year
SELECT
    customer_id,
    YEAR (order_date) order_year,
    COUNT (order_id) order_placed
FROM
    sales.orders
WHERE
    customer_id IN (1, 2)
GROUP BY
    customer_id,
    YEAR (order_date)
ORDER BY
    customer_id; 


-- HAVING – specify a search condition for a group or an aggregate.
SELECT
    customer_id,
    YEAR (order_date)order_year,
    COUNT (order_id) order_count
FROM
    sales.orders
GROUP BY
    customer_id,
    YEAR (order_date)
HAVING
    COUNT (order_id) >= 2
ORDER BY
    customer_id;


-- GROUPING SETS – generates multiple grouping sets.

-- Let’s create a new table named sales.sales_summary for the demonstration.
SELECT
    b.brand_name AS brand,
    c.category_name AS category,
    p.model_year,
    round(
        SUM (
            quantity * i.list_price * (1 - discount)
        ),
        0
    ) sales INTO sales.sales_summary
FROM
    sales.order_items i
INNER JOIN production.products p ON p.product_id = i.product_id
INNER JOIN production.brands b ON b.brand_id = p.brand_id
INNER JOIN production.categories c ON c.category_id = p.category_id
GROUP BY
    b.brand_name,
    c.category_name,
    p.model_year
ORDER BY
    b.brand_name,
    c.category_name,
    p.model_year;

-- Only a example
SELECT
	brand,
	category,
	SUM (sales) sales
FROM
	sales.sales_summary
GROUP BY
	GROUPING SETS (
		(brand, category),
		(brand),
		(category),
		()
	)
ORDER BY
	brand,
	category;


-- CUBE – generate grouping sets with all combinations of the dimension columns.
-- The CUBE is a subclause of the GROUP BY clause that allows you to generate multiple grouping sets.
-- If you have N dimension columns specified in the CUBE, you will have 2^N grouping sets.
-- CUBE (d1,d2,d3) defines eight possible grouping sets:
-- (d1, d2, d3),(d1, d2),(d2, d3),(d1, d3),(d1),(d2),(d3),()

SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    CUBE(brand, category);


-- ROLLUP – generate grouping sets with an assumption of the hierarchy between input columns.
-- And the ROLLUP(d1,d2,d3) creates only four grouping sets, assuming the hierarchy d1 > d2 > d3, as follows:
-- (d1, d2, d3),(d1, d2),(d1),()
SELECT
    brand,
    category,
    SUM (sales) sales
FROM
    sales.sales_summary
GROUP BY
    ROLLUP(brand, category);


-- SUBQUERY

-- 1. The following statement shows how to use a subquery in the WHERE clause of a SELECT statement 
      -- to find the sales orders of the customers located in New York
SELECT
    order_id,
    order_date,
    customer_id
FROM
    sales.orders
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            sales.customers
        WHERE
            city = 'New York'
    )
ORDER BY
    order_date DESC;


-- 2. Nesting subquery
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > (
        SELECT
            AVG (list_price)
        FROM
            production.products
        WHERE
            brand_id IN (
                SELECT
                    brand_id
                FROM
                    production.brands
                WHERE
                    brand_name = 'Strider'
                OR brand_name = 'Trek'
            )
    )
ORDER BY
    list_price;

-- 3. subquery used in place of an expression
SELECT
    order_id,
    order_date,
    (
        SELECT
            MAX (list_price)
        FROM
            sales.order_items i
        WHERE
            i.order_id = o.order_id
    ) AS max_list_price
FROM
    sales.orders o
order by order_date desc;


-- 4. subquery used with IN operator
SELECT
    product_id,
    product_name
FROM
    production.products
WHERE
    category_id IN (
        SELECT
            category_id
        FROM
            production.categories
        WHERE
            category_name = 'Mountain Bikes'
        OR category_name = 'Road Bikes'
    );


-- 5. subquery used with ANY operator - compare a value with a single-column set of 
       -- values returned by a subquery and return TRUE the value matches any value in the set.
-- a) the following query finds the products whose list prices are greater than or equal 
   --to the average list price of any product brand.
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price >= ANY (
        SELECT
            AVG (list_price)
        FROM
            production.products
        GROUP BY
            brand_id
    )

-- b) The following example finds the products that were sold with more than two units in a sales order:
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    product_id = ANY (
        SELECT
            product_id
        FROM
            sales.order_items
        WHERE
            quantity >= 2
    )
ORDER BY
    product_name;


-- 6. subquery is used with ALL operator - compare a value with a single-column set of values returned by a subquery and return TRUE the value matches all values in the set.
-- The following query finds the products whose list price is greater than or equal to 
   -- the average list price returned by the subquery:
SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price >= ALL (
        SELECT
            AVG (list_price)
        FROM
            production.products
        GROUP BY
            brand_id
    )


-- EXISTS – test for the existence of rows returned by a subquery
-- with a correlated subquery example
SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    EXISTS (
        SELECT
            COUNT (*)
        FROM
            sales.orders o
        WHERE
            customer_id = c.customer_id
        GROUP BY
            customer_id
        HAVING
            COUNT (*) > 2
    )
ORDER BY
    first_name,
    last_name;

-- UNION – combine the result sets of two or more queries into a single result set

-- UNION operator removes all duplicate rows from the result sets. 
SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION
SELECT
    first_name,
    last_name
FROM
    sales.customers;

-- UNION ALL - if you want to retain the duplicate rows, you need to specify the ALL keyword is explicitly as shown below:
SELECT
    first_name,
    last_name
FROM
    sales.staffs
UNION ALL
SELECT
    first_name,
    last_name
FROM
    sales.customers;


-- INTERSECT – return the intersection of the result sets of two or more queries.
SELECT
    city
FROM
    sales.customers
INTERSECT
SELECT
    city
FROM
    sales.stores
ORDER BY
    city;


-- EXCEPT – find the difference between the two result sets of two input queries.
-- EXCEPT subtracts the result set of a query from another.
SELECT
    product_id
FROM
    production.products
EXCEPT
SELECT
    product_id
FROM
    sales.order_items
ORDER BY 
	product_id;
