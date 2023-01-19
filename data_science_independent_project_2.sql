-- BASIC
-- 1. Which tracks appeared in the most playlists? how many playlist did they appear in?

SELECT tracks.TrackId, tracks.Name, COUNT(*)
FROM tracks
JOIN playlist_track
	ON tracks.TrackId = playlist_track.TrackId
GROUP BY 1
ORDER BY 3 DESC;

-- 2. Which track generated the most revenue?

SELECT tracks.TrackId, 
  tracks.Name, 
  SUM(invoice_items.UnitPrice) AS 'revenue'
FROM tracks
JOIN invoice_items
	ON tracks.TrackId = invoice_items.TrackId
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- which album?

SELECT albums.Title, 
	tracks.AlbumId,
	SUM(invoice_items.UnitPrice) AS 'Total Revenue'
FROM tracks
JOIN invoice_items
	ON tracks.TrackId = invoice_items.TrackId
JOIN albums
	ON albums.AlbumId = tracks.AlbumId
GROUP BY 2
ORDER BY 3 DESC
LIMIT 10;

-- which genre?

SELECT genres.Name,
	ROUND(SUM(invoice_items.UnitPrice), 2) AS 'Total Revenue'
FROM tracks
JOIN invoice_items
	ON tracks.TrackId = invoice_items.TrackId
JOIN genres
	ON tracks.GenreId = genres.GenreId
GROUP BY 1
ORDER BY 2 DESC;

-- 3. Which countries have the highest sales revenue? What percent of total revenue does each country make up?

SELECT invoices.BillingCountry,
	ROUND(SUM(invoices.Total), 2) AS 'Total Revenue',
	ROUND(SUM(invoices.Total)/
		(SELECT SUM(invoices.Total) 
		  FROM invoices) *100, 2) AS 'Percent of Revenue'
FROM invoices
GROUP BY 1
ORDER BY 2 DESC;

-- 4. How many customers did each employee support?

SELECT employees.EmployeeId,
	employees.FirstName,
	employees.LastName,
	COUNT(customers.CustomerId) AS 'Number of Customers Supported'
FROM employees
JOIN customers
	ON employees.EmployeeId = customers.SupportRepId
GROUP BY 1;

-- What is the average revenue for each sale, and what is their total sale?

SELECT employees.EmployeeId,
	employees.FirstName,
	employees.LastName,
	ROUND(AVG(invoices.total), 2) AS 'Average Sale',
	ROUND(SUM(invoices.total), 2) AS 'Total Sale'
FROM employees
JOIN customers
	ON employees.EmployeeId = customers.SupportRepId
JOIN invoices
	ON customers.CustomerId = invoices.CustomerId
GROUP BY 1;

-- INTERMEDIATE
-- 1. Do longer or shorter length albums tend to generate more revenue?

WITH album_length AS (
	SELECT 
		tracks.AlbumId,
		COUNT(*) AS 'TrackCount'
	FROM tracks
	GROUP BY 1)
SELECT
	album_length.TrackCount AS 'Track Count',
	ROUND(SUM(invoice_items.UnitPrice), 2) AS 'Total Revenue',
	COUNT(DISTINCT album_length.AlbumID) AS 'Total # of Albums',
	ROUND(SUM(invoice_items.UnitPrice)/COUNT(DISTINCT album_length.AlbumId), 2) AS 'Average Revenue Per Album'
FROM invoice_items
JOIN tracks
	ON tracks.TrackId = invoice_items.TrackId
JOIN album_length
	ON album_length.AlbumId = tracks.AlbumId
GROUP BY 1;

-- 2. Is the number of times a track appear in any playlist a good indicator of sales?

WITH playlist_count AS (
	SELECT 
	playlist_track.TrackId AS 'TrackId',
	COUNT(*) AS 'pl_count'
	FROM playlist_track
	GROUP BY 1
	ORDER BY 2 DESC
)
SELECT 
	playlist_count.pl_count AS '# of Playlists',
	ROUND(SUM(invoice_items.UnitPrice)/COUNT(DISTINCT(playlist_count.TrackId)),2) AS 'Average Track Revenue'
FROM playlist_count
JOIN invoice_items
	ON invoice_items.TrackId = playlist_count.TrackId
GROUP BY 1;

-- ADVANCED
-- 1. How much revenue is generated each year, and what is its percent change from the previous year?
