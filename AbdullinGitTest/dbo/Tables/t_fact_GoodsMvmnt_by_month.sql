CREATE TABLE [dbo].[t_fact_GoodsMvmnt_by_month] (
    [DataTypeID]          INT            NOT NULL,
    [MovementTypeGroupID] INT            NULL,
    [DWHMovementTypeID]   INT            NULL,
    [DataSourceID]        INT            NOT NULL,
    [MonthID]             INT            NULL,
    [GoodID]              INT            NULL,
    [SupplierID]          INT            NULL,
    [StoreID]             INT            NULL,
    [BuyerID]             INT            NULL,
    [ChannelID]           INT            NULL,
    [Qty]                 FLOAT (53)     NULL,
    [CostNet]             FLOAT (53)     NULL,
    [StoreJurCode]        NUMERIC (10)   NULL,
    [StoreJurName]        NVARCHAR (150) NULL,
    [VatZakup]            NUMERIC (3)    NULL,
    [Zakup_cost_net]      FLOAT (53)     NULL,
    [Zakup_cost_grs]      FLOAT (53)     NULL,
    [NumberInvoice]       NVARCHAR (50)  NULL,
    [DateInvoice]         DATETIME       NULL
);

