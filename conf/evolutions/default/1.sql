# --- !Ups

-- init script create procs
-- Initial script to create stored procedures etc for sqlserver platform

-- create table-value-parameters
if not exists (select name  from sys.types where name = 'ebean_bigint_tvp') create type ebean_bigint_tvp as table (c1 bigint);
if not exists (select name  from sys.types where name = 'ebean_float_tvp') create type ebean_float_tvp as table (c1 float);
if not exists (select name  from sys.types where name = 'ebean_bit_tvp') create type ebean_bit_tvp as table (c1 bit);
if not exists (select name  from sys.types where name = 'ebean_date_tvp') create type ebean_date_tvp as table (c1 date);
if not exists (select name  from sys.types where name = 'ebean_time_tvp') create type ebean_time_tvp as table (c1 time);
if not exists (select name  from sys.types where name = 'ebean_uniqueidentifier_tvp') create type ebean_uniqueidentifier_tvp as table (c1 uniqueidentifier);
if not exists (select name  from sys.types where name = 'ebean_nvarchar_tvp') create type ebean_nvarchar_tvp as table (c1 nvarchar(max));

--
-- PROCEDURE: usp_ebean_drop_indices TABLE, COLUMN
-- deletes all indices referring to TABLE.COLUMN
--
CREATE PROCEDURE usp_ebean_drop_indices @tableName nvarchar(255), @columnName nvarchar(255)
AS SET NOCOUNT ON
declare @sql nvarchar(1000)
declare @indexName nvarchar(255)
BEGIN
    DECLARE index_cursor CURSOR FOR SELECT i.name from sys.indexes i
                                                           join sys.index_columns ic on ic.object_id = i.object_id and ic.index_id = i.index_id
                                                           join sys.columns c on c.object_id = ic.object_id and c.column_id = ic.column_id
                                    where i.object_id = OBJECT_ID(@tableName) AND c.name = @columnName
    OPEN index_cursor
    FETCH NEXT FROM index_cursor INTO @indexName
    WHILE @@FETCH_STATUS = 0
        BEGIN
            set @sql = 'drop index ' + @indexName + ' on ' + @tableName
            EXECUTE(@sql)

            FETCH NEXT FROM index_cursor INTO @indexName
        END
    CLOSE index_cursor
    DEALLOCATE index_cursor
END;

--
-- PROCEDURE: usp_ebean_drop_default_constraint TABLE, COLUMN
-- deletes the default constraint, which has a random name
--
CREATE PROCEDURE usp_ebean_drop_default_constraint @tableName nvarchar(255), @columnName nvarchar(255)
AS SET NOCOUNT ON
declare @tmp nvarchar(1000)
BEGIN
    select @Tmp = t1.name from sys.default_constraints t1
                                   join sys.columns t2 on t1.object_id = t2.default_object_id
    where t1.parent_object_id = OBJECT_ID(@tableName) and t2.name = @columnName

    if @Tmp is not null EXEC('alter table ' + @tableName +' drop constraint ' + @tmp)
END;

--
-- PROCEDURE: usp_ebean_drop_constraints TABLE, COLUMN
-- deletes constraints and foreign keys refering to TABLE.COLUMN
--
CREATE PROCEDURE usp_ebean_drop_constraints @tableName nvarchar(255), @columnName nvarchar(255)
AS SET NOCOUNT ON
declare @sql nvarchar(1000)
declare @constraintName nvarchar(255)
BEGIN
    DECLARE name_cursor CURSOR FOR
        SELECT cc.name from sys.check_constraints cc
                                join sys.columns c on c.object_id = cc.parent_object_id and c.column_id = cc.parent_column_id
        where parent_object_id = OBJECT_ID(@tableName) AND c.name = @columnName
        UNION SELECT fk.name from sys.foreign_keys fk
                                      join sys.foreign_key_columns fkc on fkc.constraint_object_id = fk.object_id
            and  fkc.parent_object_id = fk.parent_object_id
                                      join sys.columns c on c.object_id = fkc.parent_object_id and c.column_id = fkc.parent_column_id
        where fkc.parent_object_id = OBJECT_ID(@tableName) AND c.name = @columnName

    OPEN name_cursor
    FETCH NEXT FROM name_cursor INTO @constraintName
    WHILE @@FETCH_STATUS = 0
        BEGIN
            set @sql = 'alter table ' + @tableName + ' drop constraint ' + @constraintName
            EXECUTE(@sql)

            FETCH NEXT FROM name_cursor INTO @constraintName
        END
    CLOSE name_cursor
    DEALLOCATE name_cursor
END;

--
-- PROCEDURE: usp_ebean_drop_column TABLE, COLUMN
-- deletes the column annd ensures that all indices and constraints are dropped first
--
CREATE PROCEDURE usp_ebean_drop_column @tableName nvarchar(255), @columnName nvarchar(255)
AS SET NOCOUNT ON
declare @sql nvarchar(1000)
BEGIN
    EXEC usp_ebean_drop_indices @tableName, @columnName
    EXEC usp_ebean_drop_default_constraint @tableName, @columnName
    EXEC usp_ebean_drop_constraints @tableName, @columnName

    set @sql = 'alter table ' + @tableName + ' drop column ' + @columnName
    EXECUTE(@sql)
END;

create table [dbo].[Location] (
  [Id]                        numeric(19) identity(1,1) not null,
  [Name]                      nvarchar(255),
  constraint pk_location primary key ([Id])
  );

create table [dbo].[Company] (
  [Id]                        numeric(19) identity(1,1) not null,
  [Name]                      nvarchar(255),
  [LocId]                     numeric(19),
  constraint pk_company primary key ([Id])
  );

create table [dbo].[Computer] (
  [Id]                        numeric(19) identity(1,1) not null,
  [Name]                      varchar(255),
  [Introduced]                datetime2,
  [Discontinued]              datetime2,
  [CompanyId]                 numeric(19),
  constraint pk_computer primary key ([Id]))
;

alter table [dbo].[Computer] add constraint fk_computer_company_1 foreign key ([CompanyId]) references [dbo].[Company] ([Id]) on delete cascade on update cascade;
create index ix_computer_company_1 on computer ([CompanyId]);


# --- !Downs

IF OBJECT_ID('fk_computer_company_1', 'F') IS NOT NULL alter table [dbo].[Computer] drop constraint fk_computer_company_1;


if exists (select name  from sys.types where name = 'ebean_bigint_tvp') drop type ebean_bigint_tvp;
if exists (select name  from sys.types where name = 'ebean_float_tvp') drop type ebean_float_tvp;
if exists (select name  from sys.types where name = 'ebean_bit_tvp') drop type ebean_bit_tvp;
if exists (select name  from sys.types where name = 'ebean_date_tvp') drop type ebean_date_tvp;
if exists (select name  from sys.types where name = 'ebean_time_tvp') drop type ebean_time_tvp;
if exists (select name  from sys.types where name = 'ebean_uniqueidentifier_tvp') drop type ebean_uniqueidentifier_tvp;
if exists (select name  from sys.types where name = 'ebean_nvarchar_tvp') drop type ebean_nvarchar_tvp;

IF OBJECT_ID('company', 'U') IS NOT NULL drop table company;

IF OBJECT_ID('computer', 'U') IS NOT NULL drop table computer;

