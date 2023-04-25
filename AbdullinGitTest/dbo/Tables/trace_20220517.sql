CREATE TABLE [dbo].[trace_20220517] (
    [RowNumber]    INT            IDENTITY (0, 1) NOT NULL,
    [EventClass]   INT            NULL,
    [TextData]     NTEXT          NULL,
    [Duration]     BIGINT         NULL,
    [SPID]         INT            NULL,
    [DatabaseID]   INT            NULL,
    [DatabaseName] NVARCHAR (128) NULL,
    [LoginName]    NVARCHAR (128) NULL,
    [StartTime]    DATETIME       NULL,
    [EndTime]      DATETIME       NULL,
    [CPU]          INT            NULL,
    [Reads]        BIGINT         NULL,
    [RowCounts]    BIGINT         NULL,
    [Writes]       BIGINT         NULL,
    [BinaryData]   IMAGE          NULL,
    PRIMARY KEY CLUSTERED ([RowNumber] ASC)
);

