IF NOT EXISTS (SELECT name FROM sysobjects WHERE name = 'sp_batch_insert' AND type = 'P')
    exec sp_executesql N'CREATE PROCEDURE sp_batch_insert @tempTableName nvarchar(100), @tableName nvarchar(100) AS 
		EXECUTE (''INSERT into ['' + @tableName + ''] SELECT * FROM ['' + @tempTableName + '']'') 
		EXECUTE (''truncate table ['' + @tempTableName + '']'')'
GO

CREATE TABLE FirewallLog (
    [servername]         nvarchar(128),
    [logTime]            datetime, 
    [protocol]           varchar(32),
    [SourceIP]           bigint,
    [SourcePort]         int,
    [DestinationIP]      bigint,
    [DestinationPort]    int,
    [OriginalClientIP]   bigint,
    [SourceNetwork]      nvarchar(128),
    [DestinationNetwork] nvarchar(128),
    [Action]             smallint,
    [resultcode]         int, 
    [rule]              nvarchar(128), 
    [ApplicationProtocol] nvarchar(128),
    [Bidirectional]      smallint,
    [bytessent]          bigint,
    [bytessentDelta]     bigint,
    [bytesrecvd]         bigint,
    [bytesrecvdDelta]    bigint,
    [connectiontime]     int,
    [connectiontimeDelta] int,
    [SourceProxy]        varchar(32), 
    [DestinationProxy]   varchar(32),
    [SourceName]         varchar(255),
    [DestinationName]    varchar(255),
    [ClientUserName]     varchar(514),
    [ClientAgent]        varchar(255),
    [sessionid]          int,
    [connectionid]       int,
    [Interface]          varchar(25),
    [IPHeader]           varchar(255),
    [Payload]            varchar(255),
    [GmtLogTime]            datetime	
)
	
CREATE CLUSTERED INDEX [IX_FirewallLog_DateTime] ON [FirewallLog]([logTime]) ON [PRIMARY]

GO	