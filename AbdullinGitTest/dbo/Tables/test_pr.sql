CREATE TABLE [dbo].[test_pr] (
    [ИДПроизвИмп]                 BIGINT          NULL,
    [Код_производителя_импортера] NVARCHAR (1024) NOT NULL,
    [Наименование_производителя]  NVARCHAR (1024) NOT NULL,
    [ИНН_производителя]           NVARCHAR (50)   NOT NULL,
    [КПП_производителя]           NVARCHAR (50)   NULL
);

