﻿CREATE TABLE [dbo].[table1_tiny] (
    [Код_производителя_импортера]                     NVARCHAR (1024) NOT NULL,
    [Наименование_производителя]                      NVARCHAR (1024) NOT NULL,
    [ИНН_производителя]                               NVARCHAR (50)   NOT NULL,
    [КПП_производителя]                               NVARCHAR (50)   NULL,
    [Объект]                                          NVARCHAR (1024) NOT NULL,
    [Адрес_магазина]                                  NVARCHAR (1024) NULL,
    [Код_вида_продукции]                              NVARCHAR (50)   NOT NULL,
    [Код_номенклатуры]                                NVARCHAR (50)   NOT NULL,
    [Наименование_номенклатуры]                       NVARCHAR (1024) NULL,
    [Остаток_на_начало_отчетного_периода]             MONEY           NULL,
    [Сумма_закупки_в_декалитрах_орг_производителей]   MONEY           NULL,
    [Сумма_закупки_в_декалитрах_орг_Оптовой_торговли] MONEY           NULL,
    [Сумма_закупки_в_декалитрах_импорт]               MONEY           NULL,
    [Cумма_по_возвратам_поставщику_в_декалитрах]      TINYINT         NULL,
    [Прочий_расход]                                   MONEY           NULL,
    [Реализация]                                      MONEY           NULL,
    [Остаток_на_конец]                                MONEY           NULL,
    [Литраж]                                          MONEY           NULL,
    [Код_поставщика]                                  NVARCHAR (1024) NULL,
    [В_том_числе_с_марками_старого_образца]           MONEY           NULL,
    [Сумма_закупки_в_декалитрах]                      MONEY           NULL,
    [Всего_расход]                                    MONEY           NULL,
    [Расход_по_перемещениям]                          MONEY           NULL,
    [Приход_по_перемещениям]                          MONEY           NULL,
    [Прочие_поступления]                              MONEY           NULL,
    [Поступление_возврат_от_покупателей]              MONEY           NULL,
    [Опт_приход]                                      MONEY           NULL,
    [Опт_расход]                                      MONEY           NULL
);

