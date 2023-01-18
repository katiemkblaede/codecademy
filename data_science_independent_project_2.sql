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
	COUNT(customers.CustomerId) AS 'Number of Customers Supported'
FROM employees
JOIN customers
	ON employees.EmployeeId = customers.SupportRepId
GROUP BY 1
ORDER BY 2 DESC;

-- What is the average revenue for each sale?

