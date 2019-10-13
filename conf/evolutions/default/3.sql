-- # --- Sample dataset

# --- !Ups

CREATE FUNCTION fnGetCompanyWithLocation(@location INT)
    RETURNS @companyTable TABLE
                          (
                              [Id]           INT NOT NULL,
                              [Name]         VARCHAR(25),
                              [LocId]        NUMERIC(19),
                              [LocationName] NVARCHAR(255)
                          )
AS
BEGIN
    INSERT
    INTO @companyTable
    SELECT c.[Id], c.[Name], c.[LocId], l.[Name] as LocationName
    FROM Company c
    INNER JOIN Location l on c.[LocId] = l.[Id]
    WHERE c.[LocId] = @location
    RETURN
END;

# --- !Downs

DROP FUNCTION fnGetCompanyWithLocation;
