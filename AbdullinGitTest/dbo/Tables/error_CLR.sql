CREATE TABLE [dbo].[error_CLR] (
    [date]  DATE            CONSTRAINT [DF_error_CLR_date] DEFAULT (CONVERT([date],getdate())) NULL,
    [error] NVARCHAR (2000) NULL
);

