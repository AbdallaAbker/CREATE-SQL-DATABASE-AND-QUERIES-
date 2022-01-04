
--- CREATE A DATABASE AND BUILD QUERIES RETRIEVE DATA IN SQL SERVER

--- Question 1 - TOP GENRE   - Top selling genre by total sales for Germany, Canada, USA, and France? 
--- Question 2 - Top 25 Artist - List Top 25 Artist by revenue and how many minutes the song is being played?  
--- Question 3 - The Revenue Generator - Which composer with highest average revenue per song for top selling genre betwenn 2010 and 2012

---TEAM 2 SQL final Project

----------------------------------------
USE Music
GO
--- Find Primary key columns in each table


update [dbo].[Album]
set AlbumId	= 1
where albumid is null;
GO

ALTER TABLE album
	ALTER COLUMN albumid int NOT NULL;
	
ALTER TABLE Album
	ADD CONSTRAINT FK_Album_Albumid PRIMARY KEY CLUSTERED (albumid);

ALTER TABLE Artist
	ALTER COLUMN artistid int NOT NULL;
GO
ALTER TABLE Artist
	ADD CONSTRAINT FK_Artist_Artistid PRIMARY KEY CLUSTERED (artistid);
GO
ALTER TABLE Customer
	ALTER COLUMN customerid int NOT NULL;
GO
ALTER TABLE Customer
	ADD CONSTRAINT FK_customer_customerid PRIMARY KEY CLUSTERED (customerid);
GO
ALTER TABLE Employee
	ALTER COLUMN employeeid int NOT NULL;
GO
ALTER TABLE Employee
	ADD CONSTRAINT FK_employee_employeeid PRIMARY KEY CLUSTERED (employeeid);
GO
ALTER TABLE genre
	ALTER COLUMN genreid int NOT NULL;
GO
ALTER TABLE genre
	ADD CONSTRAINT FK_genre_genreid PRIMARY KEY CLUSTERED (genreid);
GO
ALTER TABLE invoice
	ALTER COLUMN invoiceid int NOT NULL;
GO
ALTER TABLE invoice
	ADD CONSTRAINT FK_invoice_invoiceid PRIMARY KEY CLUSTERED (invoiceid);
GO
ALTER TABLE invoiceline
	ALTER COLUMN invoicelineid int NOT NULL;
GO
ALTER TABLE invoiceline
	ADD CONSTRAINT FK_invoiceline_invoicelineid PRIMARY KEY CLUSTERED (invoicelineid);
GO
ALTER TABLE mediatype
	ALTER COLUMN mediatypeid int NOT NULL;
GO
ALTER TABLE mediatype
	ADD CONSTRAINT FK_mediatype_mediatypeid PRIMARY KEY CLUSTERED (mediatypeid);
GO
ALTER TABLE playlist
	ALTER COLUMN playlistid int NOT NULL;
GO
ALTER TABLE playlist
	ADD CONSTRAINT FK_playlist_playlistid PRIMARY KEY CLUSTERED (playlistid);
GO
ALTER TABLE PlaylistTrack
	ALTER COLUMN Playlistid int NOT NULL;
GO
ALTER TABLE PlaylistTrack
	ALTER COLUMN Trackid int NOT NULL;
GO
ALTER TABLE PlaylistTrack
	ADD CONSTRAINT FK_PlaylistTrack PRIMARY KEY (PlaylistId, TrackId)
GO
ALTER TABLE Track
	ALTER COLUMN Trackid int NOT NULL;
GO
ALTER TABLE Track
	ADD CONSTRAINT FK_Track_Trackid PRIMARY KEY CLUSTERED (Trackid);
GO
--- Try to find the foreign keys for tables to connect in database.

alter table [dbo].[Album]
alter column [ArtistId] int not null

alter table[dbo].[Album]
add constraint ArtistID_FK 
foreign key ([ArtistId])
references  [dbo].[Artist]([ArtistId])


alter table [dbo].[Customer]
alter column [SupportRepId] int not null;

alter table [dbo].[Customer]
add constraint SupportRepID_FK
foreign key ([SupportRepId])
references [dbo].[Employee] ([EmployeeId]);

alter table [dbo].[Employee]
alter column [ReportsTo] int;

alter table [dbo].[Employee]
add constraint selfrefrence_FK
foreign key ([ReportsTo])
References [dbo].[Employee] ([EmployeeId]);

alter table invoice
alter column customerid int not null;

alter table invoice
add constraint customerid_FK
foreign key ([CustomerId])
references [dbo].[Customer] ([CustomerId]);

alter table invoiceline
alter column invoiceid int not null;

alter table invoiceline
add constraint invoiceid_fk
foreign key (invoiceid)
references [dbo].[Invoice] ([InvoiceId]);

alter table invoiceline
alter column trackid int not null;

alter table invoiceline
add constraint trackid_fk
foreign key (trackid)
references [dbo].[Track] ([TrackId]);

alter table playlisttrack
add constraint playlistid_fk
foreign key ([PlaylistId])
references [dbo].[Playlist]([PlaylistId]);


alter table [dbo].[PlaylistTrack]
add constraint trackid_fk1
foreign key (trackid)
references track (trackid)

alter table track
alter column albumid int not null

alter table track
alter column mediatypeid int not null

alter table track
alter column genreid int not null

alter table track
add constraint albumid_fk
foreign key (albumid)
references album (albumid)

alter table track
add constraint mediatypeid_fk
foreign key (mediatypeid)
references mediatype ([MediaTypeId])

alter table track
add constraint genreid_fk
foreign key (genreid)
references genre (genreid)

--- Question 1 - Revenue by Genre and Country 

SELECT *
FROM
(Select
g.
name AS Genre,
i.BillingCountry AS Country,
SUM(il.UnitPrice) [Total Sales]

From Invoice as i
JOIN invoiceline AS il ON il.invoiceid = i.invoiceid
JOIN track AS t ON t.trackid = il.trackid
JOIN genre AS g ON g.genreid = t.genreid 
WHERE i.BillingCountry = 'Germany' or i.BillingCountry = 'Canada' or i.BillingCountry = 'USA' or i.BillingCountry = 'France'

GROUP BY i.BillingCountry, g.Name) d
PIVOT  ( MAX([Total Sales]) for country in (Canada, Germany, USA, France) ) piv;



--- Question 2 - Top 25 Artist

SELECT TOP 25
	a.ArtistId as [Artist Id],
	a.name as Artist,
	ROUND (SUM(c.unitprice * c.quantity),2) as [Total Sales],
	ROUND (SUM(c.Quantity * t.Milliseconds)*0.00001667,2) as [Min Played]
	
FROM dbo.Artist AS a
	
RIGHT JOIN dbo.Album AS b  ON  a.ArtistId = b.ArtistId
LEFT JOIN dbo.Track as t ON b.AlbumId = t.AlbumId
RIGHT JOIN dbo.InvoiceLine c ON c.TrackId = t.TrackId


GROUP BY a.ArtistId, a.Name

ORDER BY [Total Sales] DESC

--- Question 3 - The revenue Generator

SELECT TOP 10 Track.Composer ,
(SELECT TOP 1 table1.Name FROM Genre table1 WHERE table1.GenreId = GenreId) AS [Genre Name],
COUNT(composer) AS [Songs Count],
SUM(track.UnitPrice) AS [Total Revenue Per Composer]
FROM Genre JOIN Track
ON Genre.GenreId = Track.GenreId
JOIN InvoiceLine ON Track.TrackId = InvoiceLine.TrackId
JOIN Invoice ON invoice.InvoiceId = InvoiceLine.InvoiceLineId
WHERE Track.composer is not null AND YEAR(invoicedate) IN (2010, 2012)
GROUP BY Track.Composer
ORDER BY [Songs Count] desc

