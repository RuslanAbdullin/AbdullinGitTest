CREATE TABLE [dbo].[config_CLR] (
    [id]          INT             IDENTITY (1, 1) NOT NULL,
    [exec_query]  NVARCHAR (1024) NULL,
    [start_time]  DATETIME        NULL,
    [end_time]    DATETIME        NULL,
    [exec_status] INT             NULL,
    [error]       NVARCHAR (1024) NULL,
    [user]        NVARCHAR (128)  CONSTRAINT [DF_config_CLR_user] DEFAULT (suser_sname()) NULL,
    [date_create] DATETIME        CONSTRAINT [DF_config_CLR_date_create] DEFAULT (getdate()) NULL,
    [session_id]  INT             NULL
);


GO
CREATE CLUSTERED INDEX [ClusteredIndex-20220912-135733]
    ON [dbo].[config_CLR]([id] ASC);

