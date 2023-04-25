CREATE TABLE [dbo].[RAM_process] (
    [Name]      NVARCHAR (255) NULL,
    [RAM]       FLOAT (53)     NULL,
    [date_time] DATETIME       DEFAULT (getdate()) NULL
);

