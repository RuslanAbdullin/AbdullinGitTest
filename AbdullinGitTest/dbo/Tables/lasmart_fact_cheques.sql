CREATE TABLE [dbo].[lasmart_fact_cheques] (
    [ID_CHEQUE]        BIGINT          NULL,
    [dt]               INT             NULL,
    [TimeID]           INT             NULL,
    [CHEQUE_TYPE]      NVARCHAR (2000) NULL,
    [QUANTITY]         MONEY           NULL,
    [PRICE]            MONEY           NULL,
    [SUMM_DISCOUNT]    MONEY           NULL,
    [SUMM_CHEQUE_ITEM] MONEY           NULL,
    [ID_Store]         INT             NOT NULL,
    [ID_GOODS]         BIGINT          NULL,
    [ID_SUPPLIER]      INT             NOT NULL,
    [SUM_ACC]          MONEY           NULL,
    [COST]             MONEY           NULL,
    [Discount_Name]    NVARCHAR (2000) NULL
);

