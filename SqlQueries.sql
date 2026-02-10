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
