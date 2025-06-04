use mavenmovies;
/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

select 
	staff.first_name, 
    staff.last_name,
    ad.address, 
    ad.district, 
    ci.city, 
    co.country
from store s
	LEFT JOIN staff on s.manager_staff_id = staff.staff_id
    LEFT JOIN address ad on s.address_id = ad.address_id
    LEFT JOIN city ci on ad.city_id = ci.city_id
    LEFT JOIN country co on ci.country_id = co.country_id
;
	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

select
	inv.store_id, 
    inv.inventory_id, 
    f.title, 
    f.rating, 
    f.rental_rate, 
    f.replacement_cost
from inventory  inv
	LEFT JOIN film f on inv.film_id = f.film_id;

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

select 
	inv.store_id, 
    f.rating, 
    COUNT(inventory_id) as inventory_items
from inventory inv
	LEFT JOIN film f on inv.film_id = f.film_id
group by 
	inv.store_id,
    f.rating
;

/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 

select 
	store_id, 
    ca.name, 
	COUNT(inv.inventory_id) as films, 
    AVG(f.replacement_cost) as avg_rep_cost, 
    SUM(f.replacement_cost) as total_rep_cost
from inventory inv
 	LEFT JOIN film f on inv.film_id = f.film_id
	LEFT JOIN film_category fc on f.film_id = fc.film_id
	LEFT JOIN category ca on ca.category_id = fc.category_id
group by 
	store_id, 
    ca.name
ORDER BY SUM(f.replacement_cost) desc;

/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

select
	cu.first_name, 
    cu.last_name, 
    cu.store_id,
    cu.active, 
    ad.address, 
    ci.city, 
    co.country
from customer cu
	LEFT JOIN address ad on cu.address_id = ad.address_id
    LEFT JOIN city ci on ad.city_id = ci.city_id
    LEFT JOIN country co on ci.country_id = co.country_id;

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

select
	cu.first_name, 
    cu.last_name, 
    count(r.rental_id) as total_rentals, 
    SUM(p.amount) as total_payment
from customer cu
	LEFT JOIN rental r on cu.customer_id = r.customer_id
    LEFT JOIN payment p on r.rental_id = p.rental_id
group by 
	cu.first_name,
    cu.last_name
ORDER BY 
	SUM(p.amount) desc;
    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

select
	'investor' as type, 
    first_name, 
    last_name, 
    company_name
from investor
UNION 
SELECT 
	'advisor' as type, 
    first_name, 
    last_name, 
    NULL
from advisor;

/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

select
	CASE 
		WHEN aa.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN aa.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards, 
    AVG(CASE WHEN aa.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
from actor_award aa
group by 
	CASE 
		WHEN aa.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN aa.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END





