IF NOT EXISTS (SELECT name FROM sysobjects WHERE name = 'sp_batch_insert' AND type = 'P')
    exec sp_executesql N'CREATE PROCEDURE sp_batch_insert @tempTableName nvarchar(100), @tableName nvarchar(100) AS 
		EXECUTE (''INSERT into ['' + @tableName + ''] SELECT * FROM ['' + @tempTableName + '']'') 
		EXECUTE (''truncate table ['' + @tempTableName + '']'')'
GO

CREATE TABLE WebProxyLog (
  [ClientIP]        bigint,
  [ClientUserName]  nvarchar(514),
  [ClientAgent]     varchar(128),
  [ClientAuthenticate]    smallint,
  [logTime]         datetime,
  [service]         smallint,
  [servername]      nvarchar(32),
  [referredserver]  varchar(255),
  [DestHost]        varchar(255),
  [DestHostIP]      bigint,
  [DestHostPort]    int,
  [processingtime]  int,
  [bytesrecvd]      bigint,
  [bytessent]       bigint,
  [protocol]        varchar(12),
  [transport]       varchar(8),
  [operation]       varchar(24),
  [uri]             varchar(2048),
  [mimetype]        varchar(32),
  [objectsource]    smallint,
  [resultcode]      int,
  [CacheInfo]       int,
  [rule]            nvarchar(128),
  [FilterInfo]      nvarchar(256),
  [SrcNetwork]      nvarchar(128),
  [DstNetwork]      nvarchar(128),
  [ErrorInfo]       int,
  [Action]          varchar(32),
  [GmtLogTime]            datetime,
  [AuthenticationServer]  varchar(255)
)

CREATE CLUSTERED INDEX [IX_WebProxyLog_DateTime] ON [WebProxyLog]([logTime]) ON [PRIMARY]

GO

