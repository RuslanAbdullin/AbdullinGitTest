CREATE TABLE [dbo].[table2] (
    [Код_поставщика]                                   NVARCHAR (1024) NULL,
    [Наименование_поставщика]                          NVARCHAR (1024) NULL,
    [ИНН_поставщика]                                   NVARCHAR (1024) NULL,
    [КПП_поставщика]                                   NVARCHAR (1024) NULL,
    [Признак_Оптовик_Производитель_Импортер]           NVARCHAR (1024) NULL,
    [Дата_ТТН]                                         NVARCHAR (1024) NULL,
    [Номер_ТТН]                                        NVARCHAR (1024) NULL,
    [Код_номенклатуры]                                 NVARCHAR (1024) NULL,
    [Наименование_номенклатуры]                        NVARCHAR (200)  NULL,
    [Страна_производитель]                             NVARCHAR (1024) NULL,
    [КПП_Грузоотправителя]                             NVARCHAR (1024) NULL,
    [Литраж]                                           FLOAT (53)      NULL,
    [Объект]                                           NVARCHAR (1024) NULL,
    [Адрес_магазина]                                   NVARCHAR (1024) NULL,
    [Сумма_закупки_в_декалитрах]                       MONEY           NULL,
    [Cумма_по_возвратам_поставщику_в_декалитрах]       MONEY           NULL,
    [прочий_расход]                                    MONEY           NULL,
    [Код_вида_продукции]                               SMALLINT        NULL,
    [Номер_лицензии]                                   NVARCHAR (1024) NULL,
    [Дата_начала_действия]                             NVARCHAR (1024) NULL,
    [Дата_окончания_действия]                          NVARCHAR (1024) NULL,
    [Орган_выдачи]                                     NVARCHAR (1024) NULL,
    [Наименование_производителя]                       NVARCHAR (1024) NULL,
    [ИНН_производителя]                                NVARCHAR (1024) NULL,
    [КПП_производителя]                                NVARCHAR (1024) NULL,
    [Номер_ГТД]                                        NVARCHAR (1024) NULL,
    [Поступление_перемещение_внутри_одной_организации] MONEY           NULL,
    [Расход_перемещение_внутри_одной_организации]      MONEY           NULL,
    [Код_производителя_импортера]                      NVARCHAR (1024) NULL
);


GO
CREATE CLUSTERED INDEX [ClusteredIndex-20220406-143622]
    ON [dbo].[table2]([Код_поставщика] ASC, [Объект] ASC, [Код_вида_продукции] ASC, [Код_производителя_импортера] ASC);

