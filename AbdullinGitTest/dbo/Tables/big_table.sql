CREATE TABLE [dbo].[big_table] (
    [dt]            INT          NULL,
    [OperTypeID]    VARCHAR (21) NULL,
    [id_store]      INT          NULL,
    [id_goods]      BIGINT       NULL,
    [id_supplier]   INT          NULL,
    [quantity_in]   MONEY        NULL,
    [quantity_out]  MONEY        NULL,
    [quantity]      MONEY        NULL,
    [Quantity_Rest] INT          NULL,
    [sale_in]       MONEY        NULL,
    [sale_out]      MONEY        NULL,
    [sale]          MONEY        NULL,
    [sale_Rest]     INT          NULL,
    [Cost_in]       MONEY        NULL,
    [Cost_out]      MONEY        NULL,
    [Cost]          MONEY        NULL,
    [Cost_Rest]     INT          NULL,
    [Price of list] MONEY        NULL
);


GO
CREATE CLUSTERED INDEX [ClusteredIndex-20220512-143229]
    ON [dbo].[big_table]([dt] ASC);


GO
CREATE NONCLUSTERED INDEX [NonClusteredIndex-20220902-173824]
    ON [dbo].[big_table]([OperTypeID] ASC);

