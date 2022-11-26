-- create tables/views/procedures/functions in repeatable form
-- create drops

-- create drop procedures
IF OBJECT_ID('dbo.spteam') IS NOT NULL
	DROP PROCEDURE dbo.spteam
IF OBJECT_ID('dbo.spteammanagers') IS NOT NULL
	DROP PROCEDURE dbo.spteammanagers


-- create drop views
IF OBJECT_ID('dbo.Invoices') IS NOT NULL
	DROP VIEW dbo.Invoices
IF OBJECT_ID('dbo.TeamReservation') IS NOT NULL
	DROP VIEW dbo.TeamReservation


-- create drop tables
IF OBJECT_ID('dbo.payment') IS NOT NULL
	DROP TABLE dbo.payment
IF OBJECT_ID('dbo.invoice') IS NOT NULL
	DROP TABLE dbo.invoice
IF OBJECT_ID('dbo.reservation') IS NOT NULL
	DROP TABLE dbo.reservation
IF OBJECT_ID('dbo.reservation_cost') IS NOT NULL
	DROP TABLE dbo.reservation_cost
IF OBJECT_ID('dbo.team') IS NOT NULL
	DROP TABLE dbo.team
IF OBJECT_ID('dbo.team_manager') IS NOT NULL
	DROP TABLE dbo.team_manager





-- Create database tables
CREATE TABLE team_manager(
	--create columns
	team_manager_id int identity
	, first_name varchar(20) NOT NULL
	, last_name varchar(20) NOT NULL
	-- place constraints
	, CONSTRAINT PK_team_manager PRIMARY KEY(team_manager_id)
)

CREATE TABLE team(
	-- create columns
	team_id int identity
	, team_name varchar(30) NOT NULL
	, age_group varchar(10)
	, number_of_players int
	, sport varchar(30)
	, team_manager_id int NOT NULL
	-- place constraints
	, CONSTRAINT PK_team PRIMARY KEY(team_id)
	, CONSTRAINT FK1_team FOREIGN KEY(team_manager_id) REFERENCES team_manager(team_manager_id)
)

CREATE TABLE reservation_cost(
	-- create columns
	reservation_cost_id int identity
	, elapsed_time varchar(20) NOT NULL
	, cost_amount varchar(30) NOT NULL
	-- place contraints
	, CONSTRAINT PK_reservation_cost PRIMARY KEY(reservation_cost_id)
)

CREATE TABLE reservation(
	-- create columns
	reservation_id int identity
	, field_name varchar(20) NOT NULL
	, team_id int NOT NULL
	, reservation_date datetime NOT NULL
	, reservation_time datetime NOT NULL
	, reservation_cost_id int NOT NULL
	-- place constraints
	, CONSTRAINT PK_reservation PRIMARY KEY(reservation_id)
	, CONSTRAINT FK1_reservation FOREIGN KEY(team_id) REFERENCES team(team_id)
	, CONSTRAINT FK2_reservation FOREIGN KEY(reservation_cost_id) REFERENCES reservation_cost(reservation_cost_id)
)

CREATE TABLE invoice(
	-- create columns
	invoice_id int identity
	, reservation_id int NOT NULL
	, invoice_status varchar(30) NOT NULL
	-- place constraints
	, CONSTRAINT PK_invoice PRIMARY KEY(invoice_id)
	, CONSTRAINT FK1_invoice FOREIGN KEY(reservation_id) REFERENCES reservation(reservation_id)
)

CREATE TABLE payment(
	-- create columns
	payment_id int identity
	, invoice_id int NOT NULL
	, payment_type varchar(20) NOT NULL
	, team_manager_id int NOT NULL
	-- place constraints
	, CONSTRAINT PK_payment PRIMARY KEY(payment_id)
	, CONSTRAINT FK1_payment FOREIGN KEY(invoice_id) REFERENCES invoice(invoice_id)
	, CONSTRAINT FK2_payment FOREIGN KEY(team_manager_id) REFERENCES team_manager(team_manager_id)
)









-- Inserting all of the current team managers into the team_manager table
INSERT INTO team_manager(first_name , last_name)
VALUES
	('John' , 'Smith')
	, ('George' , 'Walker')
	, ('Kelly' , 'Pine')
	, ('Charles' , 'Bates')
	, ('Riley' , 'Weber')
-- check the insert data
SELECT * FROM team_manager

-- Insert all the current team data into the team table
INSERT INTO team(team_name , age_group , number_of_players , sport , team_manager_id)
VALUES
	('FC Lansing' , 'U14' , '36' , 'soccer' , (SELECT team_manager_id FROM team_manager WHERE first_name = 'Kelly' AND last_name = 'Pine'))
	, ('Tornadoes' , 'U16' , '20' , 'lacrosse' , (SELECT team_manager_id FROM team_manager WHERE first_name = 'Charles' AND last_name = 'Bates'))
	, ('Panthers' , 'U12' , '24' , 'flag football' , (SELECT team_manager_id FROM team_manager WHERE first_name = 'John' AND last_name = 'Smith'))
	, ('Dynamite FC' , 'U17' , '28' , 'soccer' , (SELECT team_manager_id FROM team_manager WHERE first_name = 'George' AND last_name = 'Walker'))
	, ('Blue Crush' , 'U11' , '16' , 'lacrosse' , (SELECT team_manager_id FROM team_manager WHERE first_name = 'Riley' AND last_name = 'Weber'))
-- check the insert data
SELECT * FROM team

-- Insert all the pricing information into reservation_cost table
INSERT INTO reservation_cost(elapsed_time , cost_amount)
VALUES
	('30 minutes' , '$75.00')
	, ('45 minutes' , '$115.00')
	, ('60 minutes' , '$150.00')
	, ('90 minutes' , '$225.00')
	, ('120 minutes' , '$275.00')
-- check the insert data
SELECT * FROM reservation_cost

-- insert reservations made for one week
-- will insert new reservations for the following week as they are made
INSERT INTO reservation(field_name , team_id , reservation_date , reservation_time , reservation_cost_id)
VALUES
	('A' , (SELECT team_id FROM team WHERE team_name = 'Blue Crush') , '3/29/2021' , '5:30 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '60 minutes'))
	, ('A' , (SELECT team_id FROM team WHERE team_name = 'Blue Crush') , '3/31/2021' , '5:30 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '60 minutes'))
	, ('B' , (SELECT team_id FROM team WHERE team_name = 'FC Lansing') , '3/29/2021' , '6:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '90 minutes'))
	, ('B' , (SELECT team_id FROM team WHERE team_name = 'FC Lansing') , '3/31/2021' , '6:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '90 minutes'))
	, ('B' , (SELECT team_id FROM team WHERE team_name = 'FC Lansing') , '4/02/2021' , '6:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '90 minutes'))
	, ('A' , (SELECT team_id FROM team WHERE team_name = 'Panthers') , '3/29/2021' , '7:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '90 minutes'))
	, ('A' , (SELECT team_id FROM team WHERE team_name = 'Panthers') , '3/31/2021' , '7:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '90 minutes'))
	, ('A' , (SELECT team_id FROM team WHERE team_name = 'Panthers') , '4/02/2021' , '7:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '90 minutes'))
	, ('A' , (SELECT team_id FROM team WHERE team_name = 'Dynamite FC') , '3/30/2021' , '4:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '120 minutes'))
	, ('A' , (SELECT team_id FROM team WHERE team_name = 'Dynamite FC') , '4/01/2021' , '4:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '120 minutes'))
	, ('B' , (SELECT team_id FROM team WHERE team_name = 'FC Lansing') , '3/30/2021' , '6:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '90 minutes'))
	, ('B' , (SELECT team_id FROM team WHERE team_name = 'FC Lansing') , '4/01/2021' , '6:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '90 minutes'))
	, ('A' , (SELECT team_id FROM team WHERE team_name = 'Tornadoes') , '3/30/2021' , '6:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '60 minutes'))
	, ('A' , (SELECT team_id FROM team WHERE team_name = 'Tornadoes') , '4/01/2021' , '6:00 pm' , (SELECT reservation_cost_id FROM reservation_cost 
WHERE elapsed_time = '60 minutes'))

-- check data inputs
SELECT * FROM reservation

-- inserting data into invoice table
-- will add new invoices when new reservations are made
INSERT INTO invoice(reservation_id , invoice_status)
VALUES
	('1' , 'Paid')
	, ('2' , 'Paid')
	, ('3' , 'Paid')
	, ('4' , 'Paid')
	, ('5' , 'Paid')
	, ('6' , 'Paid')
	, ('7' , 'Paid')
	, ('8' , 'Paid')
	, ('9' , 'Paid')
	, ('10' , 'Paid')
	, ('11' , 'Paid')
	, ('12' , 'Paid')
	, ('13' , 'Paid')
	, ('14' , 'Paid')

-- check data inputs
SELECT * FROM invoice


-- inserting data into payments based on the status of the invoice table
-- will add the unpaid invoices of new reservations when they are paid
INSERT INTO payment(invoice_id , payment_type , team_manager_id)
VALUES
	('1' , 'credit card' , '5')
	, ('2' , 'credit card' , '5')
	, ('3' , 'check' , '3')
	, ('4' , 'check' , '3')
	, ('5' , 'check' , '3')
	, ('6' , 'credit card' , '1')
	, ('7' , 'credit card' , '1')
	, ('8' , 'credit card' , '1')
	, ('9' , 'credit card' , '2')
	, ('10' , 'credit card' , '2')
	, ('11' , 'cash' , '3')
	, ('12' , 'cash' , '3')
	, ('13' , 'credit card' , '4')
	, ('14' , 'credit card' , '4')

-- check data inputs
SELECT * FROM payment



-- create a stored procedure to add new team managers
GO
CREATE PROCEDURE spteammanagers(@first_name varchar(20) , @last_name varchar(20)) 
AS
BEGIN
	INSERT INTO team_manager (first_name, last_name)
	VALUES (@first_name, @last_name)
	RETURN @@identity
END
-- execute our stored procedure to insert more team managers
EXEC spteammanagers 'Frida' , 'Jones'
EXEC spteammanagers 'Jonas' , 'Gray'
EXEC spteammanagers 'Cody' , 'Davidson'
-- check our data table
SELECT * FROM team_manager



-- create a stored procedure to add new teams
GO
CREATE PROCEDURE spteam(@teamname varchar(20) , @agegroup varchar(10) , @teamsize int , @sport varchar(30) , @teammanager int) 
AS
BEGIN
	INSERT INTO team (team_name , age_group , number_of_players , sport , team_manager_id)
	VALUES (@teamname, @agegroup, @teamsize, @sport, @teammanager)
	RETURN @@identity
END
-- execute our stored procedure to insert more teams
EXEC spteam 'Rangers', 'U13', '26', 'soccer', '6'
EXEC spteam 'Rapids FC' , 'U16' , '19' , 'soccer' , '7'
EXEC spteam 'Rapids FC', 'U14', '25', 'soccer', '7'
EXEC spteam 'Tornadoes', 'U14', '16', 'lacrosse', '4'
EXEC spteam 'Dynamite FC', 'U15', '18', 'soccer', '8'

-- check data input
SELECT * FROM team


-- create view of 
GO
CREATE VIEW TeamReservation AS
	SELECT
		reservation_id
		, field_name
		, reservation_date
		, reservation_time
	FROM reservation
	GROUP BY
		reservation_id
		, field_name
		, reservation_date
		, reservation_time
-- check view
SELECT * FROM TeamReservation
ORDER BY field_name, reservation_date, reservation_time



-- create view of payments
GO
CREATE VIEW Invoices as
SELECT
	invoice.invoice_id as invoice_id
	, reservation.reservation_date as reservation_date
	, reservation_cost.cost_amount as cost_amount
	, invoice.invoice_status as invoice_status
FROM reservation 
INNER JOIN invoice on invoice.invoice_id = invoice_id
INNER JOIN reservation_cost on reservation_cost.cost_amount = cost_amount
GROUP BY
	invoice_id
	, reservation_date
	, cost_amount
	, invoice_status

-- view
GO
SELECT * FROM Invoices









