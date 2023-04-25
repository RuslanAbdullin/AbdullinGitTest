CREATE TABLE [dbo].[t_sup_log_Mainteanance] (
    [date_time]     DATETIME        NULL,
    [database_name] NVARCHAR (64)   CONSTRAINT [DF_t_sup_log_Mainteanance_database_name] DEFAULT (db_name()) NULL,
    [table_name]    NVARCHAR (128)  NULL,
    [object_name]   NVARCHAR (128)  NULL,
    [type]          NVARCHAR (1024) NULL,
    [stat_name]     NVARCHAR (32)   NULL,
    [part_number]   INT             NULL,
    [query]         NVARCHAR (2048) NULL,
    [duration]      TIME (7)        NULL
);


GO
CREATE CLUSTERED INDEX [ClusteredIndex-20220519-224005]
    ON [dbo].[t_sup_log_Mainteanance]([date_time] DESC);

