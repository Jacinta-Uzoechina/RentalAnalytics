# RentalAnalytics
## Customer Retention and Content Strategy Report 
This aims at analysing customer retention for DVD Rental Co. and the competion they are getting from streaming companies.

### Objectives
Identify why customers are churning and which film categories drive the highest Lifetime Value (LTV).
  
### Technical Requirements:
- Segment Customers: Create a report categorizing customers into 'Top Tier' (high spend), 'Occasional', and 'At Risk' (no rentals in the last 30 days of the dataset) considering current date as MAX(rental_date + 2)
- Content Gap Analysis: Find categories that exist in the database but have zero rentals in certain store locations.
- Performance Metrics: Calculate the average days between rentals per customer using LEAD() or LAG() (Window Functions) to identify engagement frequency.
- Engagement Tracking: Calculate the average rental duration per category to see which genres people keep longer.
- Best Categories: summarizes revenue per category, filtered to show only categories generating above-total-average revenue.
- Create a VIEW (refreshes 5:00AM daily) marketing_targets_vw containing the names and emails of Platinum customers who haven't rented since a specific date.

### Database
dvdrentals

### Tools
PostgreSQL

### Output
Insights to support retention strategies, inventory optimization,
and content strategy decisions.
