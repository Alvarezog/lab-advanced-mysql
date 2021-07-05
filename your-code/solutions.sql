-- Challenge 1

USE publications;
CREATE TEMPORARY TABLE sales_royalty
SELECT 
ti.title_id as 'title_id',
au.au_ID as 'author_id',
(ti.price * sale.qty * ti.royalty / 100 * ta.royaltyper / 100) AS 'Royalty'
FROM authors as au
LEFT JOIN titleauthor AS ta ON ta.au_id = au.au_id
INNER JOIN titles as ti ON ti.title_id = ta.title_id
INNER JOIN sales as sale ON sale.title_id = ti.title_id
ORDER BY Royalty DESC;

CREATE TEMPORARY TABLE sales_per_title
SELECT title_id,author_id,SUM(Royalty) as "Total_Royalty"
FROM sales_royalty
GROUP BY title_id, author_id;

SELECT sales_per_title.author_id,(total_royalty + titles.advance) as "profits"
FROM sales_per_title
LEFT JOIN titles ON sales_per_title.title_id = titles.title_id
ORDER BY profits DESC;

-- Challenge 2

SELECT sales_per_title.author_id,(total_royalty + titles.advance) as "profits"
FROM (	
	SELECT title_id,author_id,SUM(Royalty) as "Total_Royalty"
	FROM (
		SELECT 
		ti.title_id as 'title_id',
		au.au_ID as 'author_id',
		(ti.price * sale.qty * ti.royalty / 100 * ta.royaltyper / 100) AS 'Royalty'
		FROM authors as au
		LEFT JOIN titleauthor AS ta ON ta.au_id = au.au_id
		INNER JOIN titles as ti ON ti.title_id = ta.title_id
		INNER JOIN sales as sale ON sale.title_id = ti.title_id
		ORDER BY Royalty DESC
		) as sales_royalty
		GROUP BY title_id, author_id 
	)as sales_per_title
LEFT JOIN titles ON sales_per_title.title_id = titles.title_id
ORDER BY profits DESC;

-- Challenge 3

CREATE TABLE most_profiting_authors
SELECT sales_per_title.author_id,(total_royalty + titles.advance) as "profits"
FROM (	
	SELECT title_id,author_id,SUM(Royalty) as "Total_Royalty"
	FROM (
		SELECT 
		ti.title_id as 'title_id',
		au.au_ID as 'author_id',
		(ti.price * sale.qty * ti.royalty / 100 * ta.royaltyper / 100) AS 'Royalty'
		FROM authors as au
		LEFT JOIN titleauthor AS ta ON ta.au_id = au.au_id
		INNER JOIN titles as ti ON ti.title_id = ta.title_id
		INNER JOIN sales as sale ON sale.title_id = ti.title_id
		ORDER BY Royalty DESC
		) as sales_royalty
		GROUP BY title_id, author_id 
	)as sales_per_title
LEFT JOIN titles ON sales_per_title.title_id = titles.title_id
ORDER BY profits DESC;