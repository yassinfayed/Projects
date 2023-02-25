CREATE DATABASE attemptmillion;
go 

CREATE PROCEDURE createAllTables
AS
BEGIN

    create table SystemUser(
    username varchar(20),
    password varchar(20)
    primary key(username)
    );

    insert into SystemUser values ('yassinfayed','Doona213')
    select* from SystemAdmin

    CREATE TABLE Fan (
        nationalID varchar(20) primary key,
        name varchar(20),
        birth_date date,
        address varchar(20),
        phone_no int,
        status bit,
        username varchar(20) UNIQUE
        foreign key (username) references SystemUser 
        on update cascade
        on delete cascade
    );

    select * from fan ;

    create table SportsAssociationManager(
    ID int primary key identity,
    name varchar(20),
    username varchar(20) UNIQUE,
    foreign key (username) references SystemUser
    );

    create table SystemAdmin(
    ID int primary key identity,
    name varchar(20),
    username varchar(20) UNIQUE,
    foreign key (username) references SystemUser
    on update cascade
    on delete cascade
    );
    insert 
into SystemAdmin
values('yassin','yassinfayed')

   
  
   

    create table Stadium(
    ID int primary key identity,
    name varchar(20) UNIQUE,
    location varchar(20),
    capacity int,
    status bit
    );

    INSERT INTO Stadium (name, location, capacity, status)
    VALUES ('Stadium A', 'Paris', 50000, 1) , ('Stadium B', 'London', 60000, 0);

    select * from allClubRepresentatives
    

    create table StadiumManager(
    ID int primary key identity,
    name varchar(20),
    stadium_ID int,
    username varchar(20) UNIQUE,
    foreign key(stadium_ID) references Stadium
    on update cascade
    on delete cascade,
    foreign key(username) references SystemUser
    on update cascade
    on delete cascade
    );

    create table Club(
    club_ID int primary key identity,
    name varchar(20) UNIQUE,
    location varchar(20)
    );


    
       

    create table ClubRepresentative (
    ID int primary key identity,
    name varchar(20),
    club_ID int,
    username varchar(20) UNIQUE,
    foreign key(username) references SystemUser
    on update cascade
    on delete cascade,
    foreign key(club_ID) references Club
    on update cascade
    on delete cascade
    );

    insert into SystemUser values('malak123','kim')
    insert into ClubRepresentative values('malak','7','malak123')
    select * from Match
    select * from StadiumManager
    select * from Stadium
    select * from SystemUser

    select* from Match

    create table Match(
    match_ID int primary key identity,
    start_time datetime,
    end_time datetime,
    host_club_ID int,
    guest_club_ID int,
    stadium_ID int,
    foreign key(host_club_ID) references Club
    on update cascade
    on delete cascade,
    foreign key(guest_club_ID) references Club
    on update no action
    on delete no action,
    foreign key(stadium_ID) references Stadium
    on update cascade
    on delete cascade
    );

    create table HostRequest(
    ID INT PRIMARY KEY identity,
    representative_ID int,
    manager_ID int,
    match_ID int,
    status varchar(20) check(status in ('unhandled','accepted','rejected')),
    foreign key (representative_ID) references Clubrepresentative
    on update cascade
    on delete cascade,
    foreign key (manager_ID) references StadiumManager
    on update no action
    on delete no action,
    foreign key (match_ID) references Match
    on update no action
    on delete no action
    );

    create table Ticket(
    ID int primary key identity,
    status bit,
    match_ID int,
    foreign key(match_ID) references Match
    on update cascade
    on delete cascade
    );

    create table TicketBuyingTransactions(
    fan_nationalID varchar(20),
    ticket_ID int,
    foreign key(fan_nationalID) references Fan
    on update cascade
    on delete cascade,
    foreign key(ticket_ID) references Ticket
    on update cascade
    on delete cascade,
    primary key(ticket_ID)
    )

END
go

select * from Ticket
go


CREATE PROC dropAllTables
AS
DROP TABLE SystemAdmin
DROP TABLE SportsAssociationManager
DROP TABLE TicketBuyingTransactions
DROP TABLE Fan
DROP TABLE Ticket
DROP TABLE HostRequest
DROP TABLE ClubRepresentative
DROP TABLE StadiumManager
DROP TABLE Match
DROP TABLE Stadium
DROP TABLE Club
DROP TABLE SystemUser
GO

CREATE PROC dropAllProceduresFunctionsViews
AS
DROP PROC createAllTables
DROP PROC dropAllTables
DROP PROC clearAllTables
DROP VIEW allAssocManagers
DROP VIEW allClubRepresentatives
DROP VIEW allStadiumManagers
DROP VIEW allFans
DROP VIEW allMatches
DROP VIEW allTickets
DROP VIEW allCLubs
DROP VIEW allStadiums
DROP VIEW allRequests
DROP PROC addAssociationManager
DROP PROC addNewMatch
DROP VIEW clubsWithNoMatches
DROP PROC deleteMatch
DROP PROC deleteMatchesOnStadium
DROP PROC addClub
DROP PROC addTicket
DROP PROC deleteClub
DROP PROC addStadium
DROP PROC deleteStadium
DROP PROC blockFan
DROP PROC unblockFan
DROP PROC addRepresentative
DROP FUNCTION viewAvailableStadiumsOn
DROP PROC addHostRequest
DROP FUNCTION allUnassignedMatches
DROP PROC addStadiumManager
DROP FUNCTION allPendingRequests
DROP PROC acceptRequest
DROP PROC rejectRequest
DROP PROC addFan
DROP FUNCTION upcomingMatchesOfClub
DROP FUNCTION availableMatchesToAttend
DROP PROC purchaseTicket
DROP PROC updateMatchTiming
DROP VIEW matchesPerTeam
DROP PROC deleteMatchesOn
DROP VIEW matchWithMostSoldTickets
DROP VIEW matchesRankedBySoldTickets
DROP PROC clubWithTheMostSoldTickets
DROP VIEW clubsRankedBySoldTickets
DROP FUNCTION stadiumsNeverPlayedOn
GO


CREATE PROC clearAllTables
AS
DELETE FROM SystemAdmin
DELETE FROM SportsAssociationManager
DELETE FROM TicketBuyingTransactions
DELETE FROM Fan
DELETE FROM Ticket
DELETE FROM HostRequest
DELETE FROM ClubRepresentative
DELETE FROM StadiumManager
DELETE FROM Match
DELETE FROM Stadium
DELETE FROM Club
DELETE FROM SystemUser
GO
exec clearAllTables
go

insert into SystemUser values('amiryassin','123')

select * from Stadium
select * from StadiumManager
select * from Ticket
select * from Match

select * from SystemAdmin

select * from SystemUser

insert into SystemAdmin values ('ay','amiryassin')

go


CREATE VIEW allAssocManagers
AS
    SELECT S2.username, S2.password, S1.name
    FROM SportsAssociationManager S1 inner join SystemUser S2
    on S1.username=S2.username
go

select * FROM allAssocManagers 
go 

CREATE VIEW allClubRepresentatives
AS
    SELECT C.username,S.password, C.name, Cl.name As Clubname
    FROM ClubRepresentative C
    INNER JOIN Club Cl
    ON C.club_ID = Cl.club_ID
    inner join SystemUser S
    on C.username=S.username
go



CREATE VIEW allStadiumManagers
AS
    SELECT S.username,S1.password, S.name, St.name AS stadium_name
    FROM StadiumManager S
    INNER JOIN Stadium St
    ON S.stadium_ID = St.ID
    inner join SystemUser S1
    on S1.username=S.username
go


CREATE VIEW allFans
AS
    SELECT F.username,S1.password,F.name, F.nationalID, F.birth_date,
           CASE
               WHEN status = 1 THEN 'unblocked'
               ELSE 'blocked'
           END AS status
    FROM Fan F
    inner join SystemUser S1
    on S1.username=F.username
go

CREATE VIEW allMatches
AS
    SELECT C1.name AS host,C2.name AS guest,M.start_time
    FROM Match M
    INNER JOIN Club C1
    on M.host_club_ID=C1.club_ID
    INNER JOIN Club C2
    on M.guest_club_ID=C2.club_ID
go

CREATE VIEW allCLubs
AS
    SELECT name, location
    FROM Club;
go

INSERT INTO Club (name, location)
VALUES ('psg', 'paris'),
       ('rm', 'madrid'),
       ('bm', 'munich');

SELECT * FROM allCLubs
go

CREATE VIEW allStadiums
AS
    SELECT name, location, capacity,
           CASE
               WHEN status = 1 THEN 'available'
               ELSE 'unavailable'
           END AS status
    FROM Stadium;
go


Create view allTickets
AS
  Select C1.name AS host,C2.name as guest,S.name as stadium,M.start_time
  from Ticket T inner join Match M
  on T.match_ID=M.match_ID
  inner join Club C1 on C1.club_ID=M.host_club_ID
  inner join Club C2 on C2.club_ID=M.guest_club_ID
  inner join Stadium S on S.ID=M.stadium_ID
go



CREATE VIEW allRequests
AS
    Select C.username as rep,S.username as manager,H.status
    from HostRequest H
    inner join Match M on H.match_ID=M.match_ID
    inner join ClubRepresentative  C on H.representative_ID=C.ID
    inner join StadiumManager S on H.manager_ID=S.ID
go


 

CREATE PROCEDURE login
@username varchar(20),
@password varchar(20) , 
@type int OUTPUT
AS
BEGIN
IF EXISTS (SELECT * FROM allAssocManagers WHERE username = @username AND password = @password)
begin
set @type = 1
end
else 
IF EXISTS (SELECT * FROM allClubRepresentatives WHERE username = @username AND password = @password)
begin
set @type = 2
end else
IF EXISTS (SELECT * FROM allStadiumManagers WHERE username = @username AND password = @password)
begin
set @type = 3
end else 
IF EXISTS (SELECT * FROM allFans WHERE username = @username AND password = @password)
begin
set @type = 4
end
else 
IF EXISTS (SELECT * FROM SystemAdmin a , SystemUser u  WHERE a.username = @username AND u.username = @username AND u.password = @password)
begin
set @type = 5
end
else
begin 
set @type = 0
end
end

go





CREATE PROCEDURE addAssociationManager
    @name varchar(20),
    @username varchar(20),
    @password varchar(20),
    @signUpSuccess int OUTPUT
    
AS
BEGIN
    IF EXISTS (SELECT * FROM SystemUser WHERE username = @Username)
    BEGIN
        SET @signUpSuccess = 0
    END
    ELSE
    BEGIN

        INSERT INTO SystemUser(username, password)
        VALUES (@username, @password);

        INSERT INTO SportsAssociationManager(name, username)
        VALUES (@name, @username);
       
        
        SET @SignUpSuccess = 1
    END
END
go


select* from allMatches
go

CREATE PROCEDURE addNewMatch
    @hostClubName varchar(20),
    @guestClubName varchar(20),
    @start datetime,
    @end datetime
AS
BEGIN
    INSERT INTO Match(start_time,end_time, host_club_ID, guest_club_ID)
    VALUES(@start,@end,
        (SELECT club_ID FROM Club WHERE name = @hostClubName),
        (SELECT club_ID FROM Club WHERE name = @guestClubName)
    );
END;
go

CREATE VIEW clubsWithNoMatches AS
    SELECT name
    FROM Club
    WHERE club_ID NOT IN (SELECT host_club_ID FROM Match)
    AND club_ID NOT IN (SELECT guest_club_ID FROM Match)
go

select * from ClubRepresentative

exec addNewMatch @hostClubName='real madrid' , @guestClubName='liverpool' , @start='2023-10-18 08:00:00' , @end='2023-10-18 08:30:00'
exec addNewMatch @hostClubName='lp' , @guestClubName='bm' , @start='2023-10-9 08:00:00' , @end='2023-10-9 08:30:00'
select * from Match
select * from ClubRepresentative
select * from HostRequest
select * from Club
select * from Stadium

select * from Match
update Match 
set stadium_ID=1
where host_club_ID=5

select* from Stadium
go


select* from allMatches
go

CREATE PROCEDURE deleteMatch
    @hostClubName varchar(20),
    @guestClubName varchar(20),
    @start datetime ,
    @end datetime
AS
BEGIN
    DELETE FROM HostRequest
    WHERE match_ID IN (SELECT M.match_ID 
    FROM Match M,Club C1,Club C2
    WHERE C1.name=@hostClubName AND C2.name=@guestClubName AND C1.club_ID=M.host_club_ID AND C2.club_ID=M.guest_club_ID AND M.start_time = @start AND M.end_time = @end)

    DELETE FROM Match
    WHERE host_club_ID = (SELECT club_ID FROM Club WHERE name = @hostClubName)
    AND guest_club_ID = (SELECT club_ID FROM Club WHERE name = @guestClubName)
END;
go


CREATE PROCEDURE deleteMatchesOnStadium
    @stadiumName varchar(20)
AS
BEGIN
   
    DELETE FROM HostRequest
    WHERE match_ID in (SELECT match_ID
    FROM Match 
    WHERE stadium_ID=(SELECT ID FROM Stadium where name=@stadiumName) and start_time>=CURRENT_TIMESTAMP)

    DELETE FROM Match
    WHERE stadium_ID = (SELECT ID FROM Stadium WHERE name = @stadiumName)
    AND start_time > CURRENT_TIMESTAMP

END;
go


CREATE PROCEDURE addClub
    @clubname varchar(20),
    @location varchar(20),
    @signUpSuccess int OUTPUT
    
AS
BEGIN
    IF EXISTS (SELECT * FROM Club c WHERE c.name = @clubname)
    BEGIN
        SET @signUpSuccess = 0
    END
    ELSE
    BEGIN
    insert into Club(name,location)
    values(@clubname,@location)
    SET @signUpSuccess = 1
    END
END;
go
select * from Stadium
select * from StadiumManager

select * from Match


delete from StadiumManager 
where name='aam'

select * from Club ;
exec addTicket @hostClub='psg' , @competingClub='bm' , @startTime='2023-10-10 08:00:00.000' ;
select * from availableMatchesToAttend('2023-10-10 08:00:00.000')  ;
select * from Match ;
select * from Ticket
go

CREATE PROCEDURE addTicket
    @hostClub VARCHAR(20),
    @competingClub VARCHAR(20),
    @startTime DATETIME
AS
BEGIN
    DECLARE @hostClubID INT, @guestClubID INT;

    SELECT @hostClubID = club_ID
    FROM Club
    WHERE name = @hostClub

       SELECT @guestClubID = club_ID
    FROM Club
    WHERE name = @competingClub

    INSERT INTO Ticket (status,match_ID)
    SELECT 1,match_ID
    FROM Match
    WHERE start_time = @startTime
        AND host_club_ID = @hostClubID
        AND guest_club_ID = @guestClubID;
END;
go




CREATE PROC deleteClub
@cname VARCHAR(20) ,
@exists int OUTPUT
AS
BEGIN
IF exists (Select * FROM Club c where c.name = @cname )  
BEGIN
SET @exists = 1 
DECLARE @Y INT
SET @Y=(
SELECT club_ID
FROM Club 
WHERE name=@cname)
DELETE FROM Match
WHERE match_ID IN (
SELECT match_ID 
FROM Match
WHERE guest_club_ID=@Y)
DELETE FROM Club 
WHERE name=@cname
END
ELSE 
SET @exists = 0
END

go


CREATE PROCEDURE addStadium 
@name varchar(20), 
@location varchar(20), 
@capacity int ,
@signUpSuccess int OUTPUT
    
AS
BEGIN
    IF EXISTS (SELECT * FROM Stadium  s WHERE s.name = @name)
    BEGIN
        SET @signUpSuccess = 0
    END
    ELSE
BEGIN
INSERT INTO Stadium (name, location, capacity , status)
VALUES (@name, @location, @capacity , 1);
SET @signUpSuccess = 0
END
END;
go




CREATE PROCEDURE deleteStadium @name varchar(20) , @exists int OUTPUT
AS
BEGIN
IF exists (SELECT * From Stadium s where s.name = @name)
BEGIN 
    SET @exists = 1 
    DECLARE @SMID INT
    SET @SMID=(
    SELECT SM.ID
    FROM Stadium S,StadiumManager SM
    WHERE S.name=@name and S.ID=SM.stadium_ID)

    DELETE FROM HostRequest 
    WHERE manager_ID=@SMID
    DELETE FROM Stadium
    WHERE name = @name;
    END
    ELSE 
    SET @exists = 0 
END;
go

select * from Fan
go


CREATE PROCEDURE blockFan @nationalID varchar(20) , @exists int OUTPUT
AS
BEGIN
IF exists (select * from allFans f where f.nationalID = @nationalID)
BEGIN
SET @exists = 1
UPDATE Fan
SET status = 0
WHERE nationalID = @nationalID;
END 
ELSE 
SET @exists = 0
END;
go

CREATE PROCEDURE unblockFan @nationalID varchar(20) , @exists int OUTPUT
AS
BEGIN
IF exists (select * from allFans f where f.nationalID = @nationalID)
BEGIN
UPDATE Fan
SET status = 1
WHERE nationalID = @nationalID;
END 
ELSE 
SET @exists = 0
END;
go



CREATE PROCEDURE addRepresentative @name varchar(20), @club_name varchar(20), @username varchar(20), @password varchar(20) , @signUpSuccess1 int OUTPUT , @signUpSuccess2 int OUTPUT , @signUpSuccess3 int OUTPUT
AS
BEGIN
DECLARE @club_ID int;
    IF EXISTS (SELECT * FROM SystemUser WHERE username = @Username)
    BEGIN
        SET @signUpSuccess1 = 0
        RETURN;
    END   
     IF NOT EXISTS (SELECT * FROM allCLubs WHERE name = @club_name )
    BEGIN
        SET @signUpSuccess2 = 0
        RETURN;
    END 
    IF exists (select * FROM allClubRepresentatives r WHERE r.Clubname = @club_name)
    BEGIN 
    SET  @signUpSuccess3 = 0
    RETURN;
    END
    ELSE
    BEGIN
Set @club_ID  = (select club_ID FROM Club WHERE name = @club_name)

INSERT INTO SystemUser (username, password)
VALUES (@username, @password);

INSERT INTO ClubRepresentative (name, club_ID, username)
VALUES (@name, @club_ID, @username);
SET @signUpSuccess1 = 1
SET @signUpSuccess2 = 1
SET @signUpSuccess3 = 1
END
END;

go




CREATE FUNCTION viewAvailableStadiumsOn(@date datetime)
RETURNS TABLE
AS
RETURN(
SELECT s.name, s.location, s.capacity
FROM Stadium s
WHERE s.status = 1
AND NOT EXISTS (
SELECT *
FROM Match m
WHERE m.stadium_ID = s.ID
AND m.start_time <= @date
AND m.end_time >= @date
)
)
go



CREATE FUNCTION viewAvailableStadiumsStarting(@date datetime)
RETURNS TABLE
AS
RETURN(
SELECT s.name, s.location, s.capacity
FROM Stadium s
WHERE s.status = 1
AND NOT EXISTS (
SELECT *
FROM Match m
WHERE m.stadium_ID = s.ID
AND m.start_time >= @date
)
)
go

SELECT* FROM HostRequest
SELECT * FROM Match
SELECT * FROM Club
SELECT * FROM Stadium
/* 2023-10-10 08:00:00.000 , id 8, hci 7, name lp */
 
select * from  HostRequest h , Match m , Club c where c.name = 'lp' and m.host_club_ID=c.club_ID and M.match_ID=h.ID and m.start_time='2023-10-10 08:00:00.000';

DECLARE @dupes2 int
EXEC addHostRequest @club_name='lp', @stadium_name='Stadium A', @match_time='2023-10-10 08:00:00.000', @dupes=@dupes2

select * from  HostRequest h , Match m , Club c where c.name = 'lp' and m.start_time='2023-10-10 08:00:00.000';

go

drop procedure addHostRequest
go

CREATE PROCEDURE addHostRequest @club_name varchar(20), @stadium_name varchar(20), @match_time datetime , @dupes int OUTPUT
AS
BEGIN
IF exists (select * from  HostRequest h , Match m , Club c where c.name = @club_name and m.start_time=@match_time and m.host_club_ID=c.club_ID and m.match_ID=h.match_ID)
BEGIN 
SET @dupes = 1
END
ELSE
BEGIN
DECLARE @club_ID int, @stadium_ID int, @manager_ID int, @representative_ID int;
 
SELECT @club_ID = club_ID
FROM Club
WHERE Club.name = @club_name

SELECT @manager_ID = S.ID
FROM StadiumManager S inner join Stadium S2
on S.stadium_ID=S2.ID
WHERE S2.name=@stadium_name

SELECT @representative_ID = ID
FROM ClubRepresentative
WHERE club_ID = @club_ID;

INSERT INTO HostRequest (representative_ID, manager_ID, match_ID, status)
VALUES (@representative_ID, @manager_ID, (SELECT match_ID FROM Match WHERE start_time = @match_time AND host_club_ID = @club_ID), 'unhandled');
SET @dupes = 0
END

END;
go

select *from HostRequest
go



CREATE FUNCTION allUnassignedMatches(@club_name varchar(20))
RETURNS TABLE
AS
RETURN(
SELECT c.name, m.start_time
FROM Match m
INNER JOIN Club c
ON m.guest_club_ID = c.club_ID
WHERE m.host_club_ID = (SELECT club_ID FROM Club WHERE name = @club_name)
AND m.stadium_ID IS NULL
)
go


CREATE PROCEDURE addStadiumManager 
@name varchar(20), 
@stadium_name varchar(20), 
@username varchar(20), 
@password varchar(20),
@signUpSuccess1 int OUTPUT , 
@signUpSuccess2 int OUTPUT ,
@signUpSuccess3 int OUTPUT
AS
BEGIN
DECLARE @stadium_ID int;

IF EXISTS (SELECT * FROM SystemUser WHERE username = @Username)
    BEGIN
        SET @signUpSuccess1 = 0
        RETURN;
    END   
     IF NOT EXISTS (SELECT * FROM allStadiums WHERE name = @stadium_name )
    BEGIN
        SET @signUpSuccess2 = 0
        RETURN;
    END 
     IF EXISTS (SELECT * FROM allStadiumManagers m WHERE m.stadium_name = @stadium_name )
    BEGIN
        SET @signUpSuccess3 = 0
        RETURN;
    END 
    ELSE
    BEGIN
SELECT @stadium_ID = ID
FROM Stadium
WHERE name = @stadium_name;

INSERT INTO SystemUser (username, password)
VALUES (@username, @password);

INSERT INTO StadiumManager (name, stadium_ID, username)
VALUES (@name, @stadium_ID, @username);
SET @signUpSuccess1 = 1
SET @signUpSuccess2 = 1
SET @signUpSuccess3 = 1
END
END
go



CREATE FUNCTION allPendingRequests(@username varchar(20))
RETURNS TABLE
AS
RETURN(
  SELECT cr.name as clubrep, c.name as guest, m.start_time
  FROM HostRequest hr
  INNER JOIN ClubRepresentative cr
    ON hr.representative_ID = cr.ID
  INNER JOIN Match m
    ON hr.match_ID = m.match_ID
  INNER JOIN Club c
    ON c.club_ID = m.guest_club_ID
  WHERE hr.manager_ID = (SELECT ID FROM StadiumManager WHERE username = @username)
    AND hr.status = 'unhandled'

);
go



CREATE PROCEDURE acceptRequest 
    @username varchar(20),
    @host_club_name varchar(20),
    @competing_club_name varchar(20),
    @start_time datetime
AS
BEGIN
    DECLARE @manager_ID int, @host_club_ID int, @competing_club_ID int, @match_ID int , @stadiumID int

    SELECT @stadiumID = s.ID
    FROM Stadium s
    INNER JOIN StadiumManager m ON s.ID = m.stadium_ID
    WHERE m.username = @username

    SELECT @manager_ID = ID FROM StadiumManager WHERE username = @username
    SELECT @host_club_ID = club_ID FROM Club WHERE name = @host_club_name
    SELECT @competing_club_ID = club_ID FROM Club WHERE name = @competing_club_name
    SELECT @match_ID = match_ID FROM Match WHERE host_club_ID = @host_club_ID AND guest_club_ID = @competing_club_ID AND start_time = @start_time

    UPDATE HostRequest SET status = 'accepted' WHERE match_ID = @match_ID

    UPDATE Match
    SET stadium_ID = @stadiumID
    WHERE match_ID = @match_ID

    UPDATE Stadium
    SET status=0
    where ID=@stadiumID
END
go


CREATE PROCEDURE rejectRequest 
    @username varchar(20),
    @host_club_name varchar(20),
    @competing_club_name varchar(20),
    @start_time datetime
AS
BEGIN
    DECLARE @manager_ID int, @host_club_ID int, @competing_club_ID int, @match_ID int

    SELECT @manager_ID = ID FROM StadiumManager WHERE name = @username
    SELECT @host_club_ID = club_ID FROM Club WHERE name = @host_club_name
    SELECT @competing_club_ID = club_ID FROM Club WHERE name = @competing_club_name
    SELECT @match_ID = match_ID FROM Match WHERE host_club_ID = @host_club_ID AND guest_club_ID = @competing_club_ID AND start_time = @start_time

    UPDATE HostRequest SET status = 'rejected' WHERE match_ID = @match_ID
END
go

select* from Fan
go


CREATE PROCEDURE addFan 
    @name varchar(20),
    @username varchar(20),
    @password varchar(20),
    @nationalID varchar(20),
    @birth_date datetime,
    @address varchar(20),
    @phone_no int,
    @signUpSuccess int OUTPUT
AS
BEGIN
    IF EXISTS (SELECT * FROM SystemUser WHERE username = @Username)
    BEGIN
        SET @signUpSuccess = 0
    END
    ELSE
    IF EXISTS (SELECT * FROM allFans f WHERE f.nationalID = @nationalID)
    BEGIN
        SET @signUpSuccess = 1
    END
    ELSE
    BEGIN
    SET @signUpSuccess = 2
    INSERT INTO SystemUser (username, password)
    VALUES (@username, @password);

    INSERT INTO Fan (nationalID, name, birth_date, address, phone_no, status, username)
    VALUES (@nationalID, @name, @birth_date, @address, @phone_no, 1, @username);
END
end;
go 

select * from upcomingMatchesOfClub('lp')
go
select * from Match
select * from ClubRepresentative
select * from Club
go 

CREATE FUNCTION upcomingMatchesOfClub (@club_name varchar(20))
RETURNS TABLE
AS
RETURN
    SELECT
        host_club.name AS host_club_name,
        guest_club.name AS guest_club_name,
        m.start_time,
        s.name AS stadium_name
    FROM Club host_club
    INNER JOIN Match m ON host_club.club_ID = m.host_club_ID
    INNER JOIN Club guest_club ON m.guest_club_ID = guest_club.club_ID
    INNER JOIN Stadium s ON m.stadium_ID = s.ID
    WHERE (host_club.name = @club_name OR guest_club.name = @club_name) AND m.start_time > GETDATE()
go



CREATE FUNCTION availableMatchesToAttend(@startDate datetime)
RETURNS TABLE
AS
RETURN
    SELECT H.name AS host_club_name, G.name AS guest_club_name, M.start_time, S.name AS stad
    FROM Match M
    INNER JOIN Club H ON M.host_club_ID = H.club_ID
    INNER JOIN Club G ON M.guest_club_ID = G.club_ID
    INNER JOIN Stadium S ON M.stadium_ID = S.ID
    WHERE M.start_time >= @startDate AND M.match_ID IN
    (
        SELECT match_ID
        FROM Ticket
        WHERE status = 1
    )
go

select * from availableMatchesToAttend('2023-10-10 08:00:00')
go

select * from Match

select* from Ticket
go


CREATE PROCEDURE purchaseTicket
    @fanNationalID varchar(20),
    @hostClubName varchar(20),
    @guestClubName varchar(20),
    @startTime datetime
AS
BEGIN

    DECLARE @matchID int, @ticketID int;

    SELECT @matchID = M.match_ID
    FROM Match M
    INNER JOIN Club H ON M.host_club_ID = H.club_ID
    INNER JOIN Club G ON M.guest_club_ID = G.club_ID
    WHERE H.name = @hostClubName AND G.name = @guestClubName AND M.start_time = @startTime;


    IF NOT EXISTS (SELECT 1 FROM Ticket WHERE match_ID = @matchID AND status = 1)
    BEGIN
        RAISERROR('No available tickets for the given match', 16, 1);
        RETURN;
    END

    SELECT TOP 1 @ticketID = ID
    FROM Ticket
    WHERE match_ID = @matchID AND status = 1

    UPDATE Ticket
    SET status = 0
    WHERE match_ID = @matchID AND ID=@ticketID

    INSERT INTO TicketBuyingTransactions(fan_nationalID, ticket_ID)
    VALUES(@fanNationalID, @ticketID);
END
go


CREATE PROCEDURE updateMatchTiming
    @hostClubName varchar(20),
    @guestClubName varchar(20),
    @currentStartTime datetime,
    @newStartTime datetime,
    @newEndTime datetime
AS
BEGIN
    declare @hostclubId int, @guestclubId int

    select @hostclubId = club_Id
    FROM Club
    where name=@hostClubName

    select @guestclubId = club_Id
    FROM Club
    where name=@guestClubName

    UPDATE Match
    SET start_time = @newStartTime, end_time = @newEndTime
    where @hostclubId=host_club_ID AND @guestClubId=guest_club_ID AND start_time=@currentStartTime
END
go


CREATE VIEW matchesPerTeam AS
SELECT
    C.name AS 'Club',
    COUNT(M.match_ID) AS 'Total Matches'
FROM Club C
LEFT JOIN Match M ON (M.host_club_ID = C.club_ID OR M.guest_club_ID = C.club_ID) AND M.start_time<=GETDATE()
GROUP BY C.name;
go


CREATE PROC deleteMatchesOn
@date DATETIME
AS
    DELETE FROM HostRequest
    WHERE match_ID IN (SELECT match_ID
    FROM Match
    WHERE DAY(start_time)=DAY(@date))

    DELETE FROM Match 
    WHERE DAY(start_time)=DAY(@date)
    GO


CREATE VIEW HELPER2 AS 
SELECT C1.name AS host_club_name,C2.name AS guest_club_name,COUNT(T.ID) AS X
FROM Match M, Ticket T,Club C1,Club C2
WHERE M.host_club_ID=C1.club_ID AND M.guest_club_ID=C2.club_ID AND M.match_ID=T.match_ID AND T.status=0
GROUP BY C1.name,C2.name
GO
CREATE VIEW matchWithMostSoldTickets AS
SELECT host_club_name,guest_club_name,MAX(X) as maxticketssold
FROM HELPER2
where HELPER2.X >= ALL(select X from HELPER2)
group by host_club_name,guest_club_name
GO



CREATE VIEW matchesRankedBySoldTickets
AS
SELECT top (100) PERCENT c1.name as hostClubName, c2.name as guestClubName, COUNT(t.ID) as ticketCount
FROM Match m
INNER JOIN Club c1 ON c1.club_ID = m.host_club_ID
INNER JOIN Club c2 ON c2.club_ID = m.guest_club_ID
INNER JOIN Ticket t ON t.match_ID = m.match_ID AND t.status = 0
GROUP BY c1.name, c2.name
ORDER BY ticketCount DESC
GO

CREATE VIEW HELPER AS 
SELECT C.name AS cname,COUNT(T.ID) AS X
FROM Match M, Ticket T,Club C
WHERE (M.host_club_ID=C.club_ID OR M.guest_club_ID=C.club_ID) AND M.match_ID=T.match_ID AND T.status=0
GROUP BY C.name
GO
CREATE PROCEDURE clubWithTheMostSoldTickets AS
SELECT cname,MAX(X) as maxticketssold
FROM HELPER
where HELPER.X >= ALL(select X from HELPER)
GROUP BY cname
GO



CREATE View clubRankedBySoldTickets
AS
SELECT top(100) percent c.name , COUNT(t.ID) AS TICKETCOUNT
FROM Club c
INNER JOIN Match m ON m.host_club_ID = c.club_ID OR m.guest_club_ID = c.club_ID
INNER JOIN Ticket t ON t.match_ID = m.match_ID AND t.status = 0
GROUP BY c.name
ORDER BY COUNT(t.ID) DESC
go



CREATE FUNCTION stadiumsNeverPlayedOn(@cname varchar(20))
RETURNS TABLE
AS 
RETURN(
(SELECT s.name,s.capacity
FROM Stadium s)
EXCEPT
(
SELECT s2.name,s2.capacity 
FROM Club c, Stadium s2,Match m
WHERE c.name=@cname and s2.ID=m.stadium_ID and (c.club_ID=m.guest_club_ID or c.club_ID=m.host_club_ID)
)
)
go

drop Function ClubsWithNoMatchesVS
go

create function ClubsWithNoMatchesVS()
RETURNS TABLE
AS
RETURN (
  SELECT c1.name AS club_1, c2.name AS club_2
  FROM Club c1
  inner join Club c2
  on (c1.club_ID <> c2.club_ID and c1.club_ID > c2.club_ID) where
  NOT EXISTS (
    SELECT 1 FROM Match
    WHERE (host_club_ID = c1.club_ID AND guest_club_ID = c2.club_ID) or (host_club_ID = c2.club_ID AND guest_club_ID = c1.club_ID)
  )
);




