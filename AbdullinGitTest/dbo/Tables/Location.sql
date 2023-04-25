CREATE TABLE [dbo].[Location] (
    [Sr.No] INT       IDENTITY (1, 1) NOT NULL,
    [Date]  DATETIME  DEFAULT (getdate()) NULL,
    [City]  CHAR (25) DEFAULT ('Bangalore') NULL
);

