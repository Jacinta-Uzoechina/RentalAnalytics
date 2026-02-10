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
	GROUP BY sc.store_id, sc.category_name
