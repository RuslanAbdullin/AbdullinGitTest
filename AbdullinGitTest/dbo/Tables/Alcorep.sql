﻿CREATE TABLE [dbo].[Alcorep] (
    [Код_поставщика]                                   NVARCHAR (50)  NOT NULL,
    [ИНН_поставщика]                                   NVARCHAR (50)  NOT NULL,
    [КПП_поставщика]                                   NVARCHAR (50)  NOT NULL,
    [Признак_Оптовик_Производитель_Импортер]           NVARCHAR (50)  NOT NULL,
    [Дата_ТТН]                                         DATETIME2 (7)  NOT NULL,
    [Номер_ТТН]                                        NVARCHAR (50)  NOT NULL,
    [Код_номенклатуры]                                 BIGINT         NOT NULL,
    [Страна_производитель]                             NVARCHAR (50)  NOT NULL,
    [КПП_Грузоотправителя]                             INT            NOT NULL,
    [Литраж]                                           FLOAT (53)     NOT NULL,
    [Объект]                                           NVARCHAR (50)  NOT NULL,
    [Сумма_закупки_в_декалитрах]                       FLOAT (53)     NOT NULL,
    [Cумма_по_возвратам_поставщику_в_декалитрах]       TINYINT        NOT NULL,
    [прочий_расход]                                    TINYINT        NULL,
    [Код_вида_продукции]                               SMALLINT       NOT NULL,
    [Наименование_производителя]                       NVARCHAR (100) NOT NULL,
    [ИНН_производителя]                                NVARCHAR (50)  NOT NULL,
    [КПП_производителя]                                NVARCHAR (50)  NULL,
    [Номер_ГТД]                                        NVARCHAR (50)  NULL,
    [Поступление_перемещение_внутри_одной_организации] TINYINT        NULL,
    [Расход_перемещение_внутри_одной_организации]      TINYINT        NULL,
    [Код_производителя_импортера]                      NVARCHAR (50)  NOT NULL
);

