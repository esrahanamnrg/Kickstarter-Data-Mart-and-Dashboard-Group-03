DROP DATABASE Kickstarter
GO
CREATE DATABASE Kickstarter
GO
ALTER DATABASE Kickstarter
SET RECOVERY SIMPLE
GO

USE Kickstarter
;

-- Create a schema to hold user views (set schema name on home page of workbook).
-- It would be good to do this only if the schema doesn't exist already.
GO
CREATE SCHEMA Kickstarter
GO


/* Drop table Kickstarter.DimProject */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.DimProject') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.DimProject
;

/* Create table Kickstarter.DimProject */
CREATE TABLE Kickstarter.DimProject(
   [ID_Project]  int   NOT NULL
,  [ProjectName]   varchar(255)  NOT NULL
, CONSTRAINT [PK_Kickstarter.DimProject] PRIMARY KEY CLUSTERED 
( [ID_Project] )
) ON [PRIMARY]
;

INSERT INTO Kickstarter.DimProject (ID_Project,ProjectName)
VALUES (1, 'Three Banks - a Comedy Short Film')
;
SET IDENTITY_INSERT Kickstarter.DimProject OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Kickstarter].[DimProject]'))
DROP VIEW [Kickstarter].[Project]
GO
CREATE VIEW [Kickstarter].[Project] AS 
SELECT [ID_Project] AS [ID_Project]
, [ProjectName] AS [ProjectName]
FROM Kickstarter.DimProject
GO


/* Create table Kickstarter.DimState */
CREATE TABLE Kickstarter.DimState(
   [ID_State]  int   NOT NULL
,  [State]   varchar(255)  NOT NULL
, CONSTRAINT [PK_Kickstarter.DimState] PRIMARY KEY CLUSTERED 
( [ID_State] )
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Kickstarter].[DimState]'))
DROP VIEW [Kickstarter].[State]
GO
CREATE VIEW [Kickstarter].[State] AS 
SELECT [ID_State] AS [ID_State]
, [State] AS [State]
FROM Kickstarter.DimState
GO

/* Drop table Kickstarter.DimState */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.DimState') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.DimState
;

/* Create table Kickstarter.DimLocation */
CREATE TABLE Kickstarter.DimLocation (
   [ID_Location]  int  NOT NULL
,  [LocationName]  varchar(255)   NOT NULL
, CONSTRAINT [PK_Kickstarter.DimLocation] PRIMARY KEY CLUSTERED 
( [ID_Location] )
) ON [PRIMARY]
;

SET IDENTITY_INSERT Kickstarter.DimLocation ON
;
INSERT INTO Kickstarter.DimLocation(ID_Location,LocationName)
VALUES (2363796, 'Beverly Hills')
;
SET IDENTITY_INSERT Kickstarter.DimCountry OFF
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Kickstarter].[DimLocation]'))
DROP VIEW [Kickstarter].[Location]
GO
CREATE VIEW [Kickstarter].[Location] AS 
SELECT [ID_Location] AS [ID_Location]
, [LocationName] AS [LocationName]
FROM Kickstarter.DimLocation
GO

/* Drop table Kickstarter.DimLocation */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.DimLocation') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.DimLocation


/* Create table Kickstarter.DimDate */
CREATE TABLE Kickstarter.DimDate(
   [ID_Date]  date  NOT NULL
,  [Day_Of_Year]  date  NOT NULL
,  [Year]   date NOT NULL
,  [Month]   date NOT NULL
,  [Quarter]   date NOT NULL
,  [Month_Name]   date NOT NULL
,  [Day_Of_Week_Name]   date NOT NULL
,  [Day_Of_Week]   date NOT NULL
,  [Day_Of_Month]   date NOT NULL
,  [Holiday_Description]   date NOT NULL
,  [Is_a_Holiday]   date NOT NULL
, CONSTRAINT [PK_Kickstarter.DimDate] PRIMARY KEY CLUSTERED 
( [ID_Date] )
) ON [PRIMARY]
;

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Kickstarter].[DimDate]'))
DROP VIEW [Kickstarter].[Date]
GO
CREATE VIEW [Kickstarter].[Date] AS 
SELECT [ID_Date] AS [ID_Date]
, [Month] AS [Month]
, [Year] AS [Year]
FROM Kickstarter.DimDate
GO

/* Drop table Kickstarter.DimDate */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.DimDate') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.DimDate


/* Drop table Kickstarter.FactProjectCampaign */
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'Kickstarter.FactProjectCampaign') AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
DROP TABLE Kickstarter.FactProjectCampaign
;

/* Create table Kickstarter.FactProjectCampaign */
CREATE TABLE Kickstarter.FactProjectCampaign(
   [ID_Location]  int   NOT NULL
,  [ID_State] int  NOT NULL
,  [ID_Date]  date   NOT NULL
,  [ID_Project]  int   NOT NULL
,  BackersCount int NOT NULL
,  ProjectGoal int NOT NULL
,  ProjectPledged int  NOT NULL
CONSTRAINT CompositeKey PRIMARY KEY ([ID_Location] , [ID_State], [ID_Date], [ID_Project] )
);

-- User-oriented view definition
GO
IF EXISTS (select * from sys.views where object_id=OBJECT_ID(N'[Kickstarter].[ProjectCampaign]'))
DROP VIEW [Kickstarter].[ProjectCampaign]
GO
CREATE VIEW [Kickstarter].[ProjectCampaign] AS 
SELECT   [ID_Location]  AS [ID_Location] 
,  [ID_State] AS [ID_State]
,  [ID_Date]  AS [ID_Date]
,  [ID_Project]  AS [ID_Project] 
,  [BackersCount]  AS [BackersCount] 
,  [ProjectGoal]  AS [ProjectGoal] 
,  [ProjectPledged ]  AS [ProjectPledged] 
FROM Kickstarter.FactProjectCampaign

ALTER TABLE Kickstarter.FactProjectCampaign ADD CONSTRAINT
   FK_Kickstarter_FactProjectCampaign_ID_Project FOREIGN KEY
   (
   ID_Project
   ) REFERENCES Kickstarter.DimProject
   ( ID_Project )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
 
ALTER TABLE Kickstarter.FactProjectCampaign ADD CONSTRAINT
   FK_Kickstarter_FactProjectCampaign_ID_Location FOREIGN KEY
   (
   ID_Location
   ) REFERENCES Kickstarter.DimLocation
   ( ID_Location )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE Kickstarter.FactProjectCampaign ADD CONSTRAINT
   FK_Kickstarter_FactProjectCampaign_ID_State FOREIGN KEY
   (
   ID_State
   ) REFERENCES Kickstarter.DimState
   ( ID_State )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;

ALTER TABLE Kickstarter.FactProjectCampaign ADD CONSTRAINT
   FK_Kickstarter_FactProjectCampaign_ID_Date FOREIGN KEY
   (
   ID_Date
   ) REFERENCES Kickstarter.DimDate
   ( ID_Date )
     ON UPDATE  NO ACTION
     ON DELETE  NO ACTION
;
