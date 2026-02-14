--Content Gap Analysis 

WITH store_categories AS(
	SELECT 
		store_id,
		c.category_id,
		c.name AS category_name
	FROM store s
	JOIN category c ON TRUE
)
SELECT 
		sc.store_id,
		sc.category_name
		COUNT (r.rental_id) AS rentals
	FROM store_categories sc
	LEFT JOIN inventory i ON sc.store_id = i.store_id
	LEFT JOIN film_category fc ON i.film_id = fc.film_id
		AND fc.category_id = sc.category_id
	LEFT JOIN rental r ON i.inventory_id = r.inventory_id
	WHERE  r.rental_id IS NULL
	GROUP BY sc.store_id, sc.category_name;

-- Performance Metrics
WITH rental_gaps AS (
    SELECT
        customer_id,
        rental_date,
        rental_date - LAG(rental_date) OVER (
            PARTITION BY customer_id ORDER BY rental_date
        ) AS days_of_gap
    FROM rental
)
SELECT
    customer_id,
    AVG(days_of_gap) AS average_days_between_rentals
FROM rental_gaps
GROUP BY customer_id;

--Engagement tracking

SELECT 
		c.name AS category,
		AVG (return_date - rental_date) AS duration
	FROM rental r 
	LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
	LEFT JOIN film_category fc ON i.film_id = fc.film_id
	LEFT JOIN category c ON fc.category_id = c.category_id
	GROUP BY c.name
	ORDER BY duration DESC;
	
-- Best categories

WITH category_revenue AS (
	SELECT 
		SUM(p.amount) AS total_revenue_per_category,
		c.name AS category
	FROM payment p
	LEFT JOIN rental r ON p.rental_id = r.rental_id
	LEFT JOIN inventory i ON r.inventory_id = i.inventory_id
	LEFT JOIN film_category fc ON i.film_id = fc.film_id
	LEFT JOIN category c ON fc.category_id = c.category_id
	GROUP BY c.name
),
average_category_revenue AS (
	SELECT AVG(cr.total_revenue_per_category) AS average_category_revenue
	FROM category_revenue cr
)
SELECT 
	cr.category, 
	cr.total_revenue_per_category AS revenue
FROM category_revenue cr
CROSS JOIN average_category_revenue acr
WHERE cr.total_revenue_per_category > acr.average_category_revenue
ORDER BY cr.total_revenue_per_category DESC;

-- View
CREATE VIEW marketing_targets_vw AS

WITH customer_levels AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email,
        COUNT(r.rental_id) AS total_rentals,
        MAX(r.rental_date) AS last_rental_date,
        CASE
            WHEN COUNT(r.rental_id) >= 50 THEN 'Platinum'
            WHEN COUNT(r.rental_id) BETWEEN 20 AND 49 THEN 'Gold'
            WHEN COUNT(r.rental_id) BETWEEN 5 AND 19 THEN 'Silver'
            ELSE 'Bronze'
        END AS customer_level
    FROM customer c
    LEFT JOIN rental r 
        ON c.customer_id = r.customer_id
    GROUP BY 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.email
)

SELECT
    CONCAT(first_name,' ', last_name) AS customer_name,
    email,
    last_rental_date
FROM customer_levels
WHERE customer_level = 'Platinum'
  AND last_rental_date <
    (SELECT MAX(rental_date) - INTERVAL '14 days' FROM rental);
