CREATE TABLE [oth].[sup_log] (
    [date_time]       DATETIME       NULL,
    [name]            NVARCHAR (255) NULL,
    [system_user]     NVARCHAR (255) NULL,
    [state_name]      NVARCHAR (255) NULL,
    [row_count]       INT            NULL,
    [err_number]      INT            NULL,
    [err_severity]    INT            NULL,
    [err_state]       INT            NULL,
    [err_object]      NVARCHAR (MAX) NULL,
    [err_line]        INT            NULL,
    [err_message]     NVARCHAR (MAX) NULL,
    [sp_id]           INT            NULL,
    [duration]        NVARCHAR (50)  NULL,
    [duration_ord]    INT            NULL,
    [description]     NVARCHAR (500) NULL,
    [input_parametrs] NVARCHAR (500) NULL
);

