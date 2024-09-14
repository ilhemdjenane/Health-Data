USE [Disease Control 3];

------------- Renaming Columns
------------------------------
EXEC sp_rename '[HealthData1].[_STATE]', 'State', 'COLUMN';
EXEC sp_rename 'HealthData1.FMONTH', 'Month', 'COLUMN';
EXEC sp_rename 'HealthData1.IDATE', 'Date', 'COLUMN';
EXEC sp_rename '[HealthData1].[IMONTH]', 'Month1', 'COLUMN';
EXEC sp_rename '[HealthData1].[IDAY]', 'Day', 'COLUMN';
EXEC sp_rename '[HealthData1].[IYEAR]', 'Year', 'COLUMN';
EXEC sp_rename '[HealthData1].GENHLTH', 'GeneralHealth', 'COLUMN'

---------Deleting unecessery columns
------------------------------------
ALTER TABLE HealthData1
DROP COLUMN [Month], [Day], [Date], [Month1];

ALTER TABLE HealthData1
DROP COLUMN [CTELENM1], [PVTRESD1], [COLGHOUS], [STATERE1], [CELPHON1], [LADULT1], 
            [COLGSEX1], [NUMADULT], [NUMMEN], [NUMWOMEN], [SAFETIME], [PVTRESD3];


ALTER TABLE HealthData1
DROP COLUMN [LANDSEX1], [RESPSLCT], [CTELNUM1], [CELLFON5],
            [HHADULT], [CADULT1], [LANDLINE], [CCLGHOUS],
            [CELLSEX1], [CSTATE1];

EXEC sp_rename '[HealthData1].[SEXVAR]', 'Gender', 'COLUMN';
EXEC sp_rename '[HealthData1].[GENHLTH]', 'GenHealth', 'COLUMN';
EXEC sp_rename '[HealthData1].[PHYSHLTH]', 'PhyHealth', 'COLUMN';
EXEC sp_rename '[HealthData1].[MENTHLTH]', 'MenHealth', 'COLUMN';
EXEC sp_rename '[HealthData1].[POORHLTH]', 'PoorHealth', 'COLUMN';
EXEC sp_rename '[HealthData1].[PRIMINSR]', 'HealthInsur', 'COLUMN';
EXEC sp_rename '[HealthData1].[PERSDOC3]', 'PersonalDoctor', 'COLUMN';
EXEC sp_rename '[HealthData1].[MEDCOST1]', 'MedCost', 'COLUMN';
EXEC sp_rename '[HealthData1].[CHECKUP1]', 'LastRoutineCheckup', 'COLUMN';
EXEC sp_rename '[HealthData1].[EXERANY2]', 'ExercisedLast30Days', 'COLUMN';


-------Cleaning General Health Column
SELECT
    GeneralHealth
FROM 
    HealthData1
GROUP BY GeneralHealth;
------
------

DELETE FROM HealthData1
WHERE GeneralHealth IS NULL;
-------
-------

DELETE FROM HealthData1
WHERE GeneralHealth  IN (7, 9);

---- Creating new column for general health 

ALTER TABLE HealthData1
ADD GeneralHealthDescription VARCHAR(50);

ALTER TABLE HealthData1
ALTER COLUMN GeneralHealth INT;

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'HealthData1' AND COLUMN_NAME = 'GeneralHealth';


---- Assigning values to the column GeneralHealthDescription
UPDATE HealthData1
SET GeneralHealthDescription = 
    CASE
        WHEN GeneralHealth = 1 THEN 'Excellent'
        WHEN GeneralHealth = 2 THEN 'Very Good'
        WHEN GeneralHealth = 3 THEN 'Good'
        WHEN GeneralHealth = 4 THEN 'Fair'
        WHEN GeneralHealth = 5 THEN 'Poor'
        ELSE 'Unknown'
    END;

SELECT
    GeneralHealthDescription,
    COUNT(GeneralHealthDescription)
FROM
    HealthData1
GROUP BY
    GeneralHealthDescription;


---- Creating new column for Physical Health
ALTER TABLE HealthData1
ADD PhysicalHealthDescription VARCHAR(50);

--- Cleaning PhyHealth column-----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
    PhyHealth,
    COUNT(PhyHealth)
FROM
    HealthData1
GROUP BY
    PhyHealth;

--- Deleting null values and 'not sure' and 'refused'
DELETE FROM HealthData1
WHERE PhyHealth IS NULL
OR PhyHealth IN (77, 99);

-----------------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE HealthData1
ALTER COLUMN PhyHealth INT
;
----------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'HealthData1' AND COLUMN_NAME = 'PhyHealth';
----------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------
UPDATE HealthData1
SET PhysicalHealthDescription =
    CASE
        WHEN PhyHealth = 88 THEN 'None'
        WHEN PhyHealth BETWEEN 1 AND 6 THEN 'Few'
        WHEN PhyHealth BETWEEN 7 AND 14 THEN 'Some'
        WHEN PhyHealth BETWEEN 15 AND 21 THEN 'Several'
        WHEN PhyHealth BETWEEN 22 AND 30 THEN 'Many'
        ELSE 'Unknown'
    END;

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    PhysicalHealthDescription,
    COUNT(PhysicalHealthDescription)
FROM
    HealthData1
GROUP BY
    PhysicalHealthDescription

-----------Cleaning MenHealth column----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
SELECT
    MenHealth,
    COUNT(MenHealth)
FROM 
    HealthData1
GROUP BY
    MenHealth;
----------------------------------------------------------------------------------------------------------------------------------------
DELETE FROM HealthData1
WHERE MenHealth IS NULL
OR MenHealth IN (77, 99);
----------------------------------------------------------------------------------------------------------------------------------------
ALTER TABLE HealthData1
ADD MentalHealthDescription VARCHAR(50);
----------------------------------------------------------------------------------------------------------------------------------------
UPDATE HealthData1
SET MentalHealthDescription =
    CASE
        WHEN MenHealth = 88 THEN 'None'
        WHEN MenHealth BETWEEN 1 AND 6 THEN 'Few'
        WHEN MenHealth BETWEEN 7 AND 14 THEN 'Some'
        WHEN MenHealth BETWEEN 15 AND 21 THEN 'Several'
        WHEN MenHealth BETWEEN 22 AND 30 THEN 'Many'
        ELSE 'Unknown'
    END;
--------------------------------------------------------------------------------------------------------------------
SELECT
    MentalHealthDescription,
    COUNT(MentalHealthDescription)
FROM 
    HealthData1
GROUP BY
    MentalHealthDescription;
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
-----------Cleaning PoorHealth column---------------
SELECT
    PoorHealth,
    COUNT(PoorHealth)
FROM 
    HealthData1
GROUP BY
    PoorHealth;
--------Deleting the unecessery rows ------------------------------------------------------------------------------------------------------------

DELETE FROM HealthData1
WHERE PoorHealth IS NULL
OR PoorHealth IN (77, 99);

--------Creating new column ------------------------------------------------------------------------------------------------------------
ALTER TABLE HealthData1
ADD PoorHealthDescription VARCHAR(50);

------------------------------------------------------------------------------------------------------------

UPDATE HealthData1
SET PoorHealthDescription =
    CASE
        WHEN PoorHealth = 88 THEN 'None'
        WHEN PoorHealth BETWEEN 1 AND 6 THEN 'Few'
        WHEN PoorHealth BETWEEN 7 AND 14 THEN 'Some'
        WHEN PoorHealth BETWEEN 15 AND 21 THEN 'Several'
        WHEN PoorHealth BETWEEN 22 AND 30 THEN 'Many'
        ELSE 'Unknown'
    END;

SELECT
    PoorHealthDescription,
    COUNT(PoorHealthDescription)
FROM 
    HealthData1
GROUP BY
    PoorHealthDescription; 
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-----------Cleaning HealthInsur Column ---------------

SELECT
    HealthInsur,
    COUNT(HealthInsur)
FROM 
    HealthData1
GROUP BY
    HealthInsur;
-------------Deleting the unecessery rows -----------------------------------------------------------------------------------------------
DELETE FROM HealthData1
WHERE HealthInsur IS NULL
OR HealthInsur IN (77, 99);

--------Creating new column ------------------------------------------------------------------------------------------------------------
ALTER TABLE HealthData1
ADD HealthInsurDescription VARCHAR(50);

UPDATE HealthData1
SET HealthInsurDescription = 
    CASE 
        WHEN HealthInsur = 88 THEN 'None'
        WHEN HealthInsur BETWEEN 1 AND 10 THEN 'Have Health Insurance'
        ELSE 'Unknown'
    END; 
------------------------------------------------------------------------------------------------------------
SELECT
    HealthInsurDescription,
    COUNT(HealthInsurDescription)
FROM 
    HealthData1
GROUP BY
    HealthInsurDescription;

------------------------------------------------------------------------------------------------------------
-----------Cleaning PersonalDoctor Column ---------------
------------------------------------------------------------------------------------------------------------
SELECT
    PersonalDoctor,
    COUNT(PersonalDoctor)
FROM 
    HealthData1
GROUP BY
    PersonalDoctor;
    ------ Deleting Rows -------------------------------------------------------------------------------------------------
DELETE FROM HealthData1
WHERE PersonalDoctor IN (7, 9)

---------- Creating a new column --------------------------------------------------------------------------------------------------
ALTER TABLE HealthData1
ADD PersonalDoctorDescription VARCHAR(50);
-------------------------------------------------------------------------------------------------
UPDATE HealthData1
SET PersonalDoctorDescription = 
    CASE 
        WHEN PersonalDoctor = 1 THEN 'One'
        WHEN PersonalDoctor = 2 THEN 'More Than One'
        WHEN PersonalDoctor = 3 THEN 'No'
        ELSE 'Unknown'
    END;

SELECT
    PersonalDoctorDescription,
    COUNT(PersonalDoctorDescription)
FROM 
    HealthData1
GROUP BY
    PersonalDoctorDescription; 

------------------------------------------------------------------------------------------------------------
-----------Cleaning MedCost Column ---------------
------------------------------------------------------------------------------------------------------------
SELECT
    MedCost,
    COUNT(MedCost)
FROM 
    HealthData1
GROUP BY
    MedCost;

------------------------------------------------------------------------------------------------------------
DELETE FROM HealthData1
WHERE MedCost IN (7, 9);

------------------------------------------------------------------------------------------------------------
ALTER TABLE HealthData1
ADD MedCostDescription VARCHAR(50);
------------------------------------------------------------------------------------------------------------

UPDATE HealthData1
SET MedCostDescription = 
    CASE 
        WHEN MedCost = 1 THEN 'Yes'
        WHEN MedCost = 2 THEN 'No'
        ELSE 'Unknown'
    END;
    
------------------------------------------------------------------------------------------------------------
SELECT
    MedCostDescription,
    COUNT(MedCostDescription)
FROM 
    HealthData1
GROUP BY
    MedCostDescription;
------------------------------------------------------------------------------------------------------------

ALTER TABLE HealthData1
ADD GenderDescription VARCHAR(50);
------------------------------------------------------------------------------------------------------------

UPDATE HealthData1
SET GenderDescription =
    CASE
        WHEN Gender = 1 THEN 'Male'
        WHEN Gender = 2 THEN 'Female'
        ELSE 'Unknown'
    END;
 
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
-----------------------------  ANALYSIS ------------------------------------------


-- State Count--------------------------------------------------------------------------------------------
WITH TotalRespondents AS (
    SELECT 
        COUNT(*) AS CountTotal
    FROM
        HealthData1
)

SELECT
    [State],
    COUNT([State]) AS COUNT,
    (COUNT([State]) * 100.0) / (SELECT CountTotal FROM TotalRespondents)
    AS StatePercentage
FROM 
    HealthData1
GROUP BY
    [State]
ORDER BY [State];


-- Gender Count --------------------------------------------------------------------------------------------
WITH TotalRespondents AS (
    SELECT 
        COUNT(Gender) AS GenderTotal
    FROM
        HealthData1
)

SELECT
    [Gender],
    COUNT([Gender]) AS COUNT,
    (COUNT(Gender) * 100.0) / (SELECT GenderTotal FROM TotalRespondents)
    AS GenderPercentage
FROM 
    HealthData1
GROUP BY
    [Gender]
ORDER BY [Gender];

------------------------------------------------------------------------------------------------------------
-----General Health Count -----------------------------------------------------------------------------------------------

WITH TotalRespondents AS (
    SELECT 
        COUNT(*) AS TotalCount
    FROM
        HealthData1
)

SELECT
    [GeneralHealthDescription],
    COUNT([GeneralHealthDescription]) AS COUNT,
    CAST(ROUND((COUNT([GeneralHealthDescription]) * 100.0) / 
    (SELECT TotalCount FROM TotalRespondents), 2) AS DECIMAL(5, 2))
    AS GeneralHealthPercentage
FROM 
    HealthData1
GROUP BY
    [GeneralHealthDescription]
ORDER BY [GeneralHealthDescription];


-----General Health Count by Gender -----------------------------------------------------------------------------------------------
WITH TotalRespondents AS (
    SELECT
        GenderDescription, 
        COUNT(GenderDescription) AS TotalCount
    FROM
        HealthData1
    GROUP BY GenderDescription
)
SELECT
    GenderDescription,
    hd.GeneralHealthDescription,
    COUNT(hd.GeneralHealthDescription) AS COUNT,
    (COUNT(hd.GeneralHealthDescription) * 100.0) / (SELECT TotalCount FROM TotalRespondents 
    WHERE TotalRespondents.GenderDescription = hd.GenderDescription)
    AS GeneralHealthPercentage
FROM 
    HealthData1 hd 
GROUP BY
    hd.GeneralHealthDescription, hd.GenderDescription
ORDER BY hd.GeneralHealthDescription, hd.GenderDescription;

------------------------------------------------------------------------------------------------------------
-----Physical Health Count -----------------------------------------------------------------------------------------------

WITH TotalRespondents AS (
    SELECT 
        COUNT(*) AS TotalCount
    FROM
        HealthData1
)

SELECT
    [PhysicalHealthDescription],
    COUNT([PhysicalHealthDescription]) AS COUNT,
    CAST(ROUND((COUNT([PhysicalHealthDescription]) * 100.0) / 
    (SELECT TotalCount FROM TotalRespondents), 2) AS DECIMAL(5, 2))
    AS GeneralHealthPercentage
FROM 
    HealthData1
GROUP BY
    [PhysicalHealthDescription]
ORDER BY [PhysicalHealthDescription];


-----Physical Health Count by Gender -----------------------------------------------------------------------------------------------
-----Mental Health Count by Gender -----------------------------------------------------------------------------------------------
WITH TotalRespondents AS (
    SELECT
        GenderDescription, 
        COUNT(GenderDescription) AS TotalCount
    FROM
        HealthData1
    GROUP BY GenderDescription
)
SELECT
    GenderDescription,
    hd.PhysicalHealthDescription,
    COUNT(hd.PhysicalHealthDescription) AS COUNT,
    (COUNT(hd.PhysicalHealthDescription) * 100.0) / (SELECT TotalCount FROM TotalRespondents 
    WHERE TotalRespondents.GenderDescription = hd.GenderDescription)
    AS PhysicalHealthPercentage
FROM 
    HealthData1 hd 
GROUP BY
    hd.PhysicalHealthDescription, hd.GenderDescription
ORDER BY hd.PhysicalHealthDescription, hd.GenderDescription;

------------------------------------------------------------------------------------------------------------
-----Mental Health Count -----------------------------------------------------------------------------------------------

WITH TotalRespondents AS (
    SELECT 
        COUNT(*) AS TotalCount
    FROM
        HealthData1
)

SELECT
    [MentalHealthDescription],
    COUNT([MentalHealthDescription]) AS COUNT,
    CAST(ROUND((COUNT([MentalHealthDescription]) * 100.0) / 
    (SELECT TotalCount FROM TotalRespondents), 2) AS DECIMAL(5, 2))
    AS MentalHealthPercentage
FROM 
    HealthData1
GROUP BY
   [MentalHealthDescription]
ORDER BY 
    [MentalHealthDescription];


-----Mental Health Count by Gender -----------------------------------------------------------------------------------------------
WITH TotalRespondents AS (
    SELECT
        GenderDescription, 
        COUNT(GenderDescription) AS TotalCount
    FROM
        HealthData1
    GROUP BY GenderDescription
)
SELECT
    GenderDescription,
    hd.MentalHealthDescription,
    COUNT(hd.MentalHealthDescription) AS COUNT,
    (COUNT(hd.MentalHealthDescription) * 100.0) / (SELECT TotalCount FROM TotalRespondents 
    WHERE TotalRespondents.GenderDescription = hd.GenderDescription)
    AS MentalHealthPercentage
FROM 
    HealthData1 hd 
GROUP BY
    hd.MentalHealthDescription, hd.GenderDescription
ORDER BY hd.MentalHealthDescription, hd.GenderDescription;


-----Poor Health Count -----------------------------------------------------------------------------------------------
WITH TotalRespondents AS (
    SELECT 
        COUNT(*) AS TotalCount
    FROM
        HealthData1
)

SELECT
    [PoorHealthDescription],
    COUNT([PoorHealthDescription]) AS COUNT,
    CAST(ROUND((COUNT([PoorHealthDescription]) * 100.0) / 
    (SELECT TotalCount FROM TotalRespondents), 2) AS DECIMAL(5, 2))
    AS PoorHealthPercentage
FROM 
    HealthData1
GROUP BY
   [PoorHealthDescription]
ORDER BY 
    [PoorHealthDescription];


-----Poor Health Count by Gender -----------------------------------------------------------------------------------------------
WITH TotalRespondents AS (
    SELECT
        GenderDescription, 
        COUNT(GenderDescription) AS TotalCount
    FROM
        HealthData1
    GROUP BY GenderDescription
)
SELECT
    GenderDescription,
    hd.PoorHealthDescription,
    COUNT(hd.PoorHealthDescription) AS COUNT,
    (COUNT(hd.PoorHealthDescription) * 100.0) / (SELECT TotalCount FROM TotalRespondents 
    WHERE TotalRespondents.GenderDescription = hd.GenderDescription)
    AS PoorHealthPercentage
FROM 
    HealthData1 hd 
GROUP BY
    hd.PoorHealthDescription, hd.GenderDescription
ORDER BY hd.PoorHealthDescription, hd.GenderDescription;

----- Health Insurance Count -----------------------------------------------------------------------------------------------
WITH TotalRespondents AS (
    SELECT 
        COUNT(*) AS TotalCount
    FROM
        HealthData1
)

SELECT
    [HealthInsurDescription],
    COUNT([HealthInsurDescription]) AS COUNT,
    CAST(ROUND((COUNT([HealthInsurDescription]) * 100.0) / 
    (SELECT TotalCount FROM TotalRespondents), 2) AS DECIMAL(5, 2))
    AS HealthInsurancePercentage
FROM 
    HealthData1
GROUP BY
   [HealthInsurDescription]
ORDER BY 
    [HealthInsurDescription];


----- Health Insurance Count by Gender -----------------------------------------------------------------------------------------------
WITH TotalRespondents AS (
    SELECT
        GenderDescription, 
        COUNT(GenderDescription) AS TotalCount
    FROM
        HealthData1
    GROUP BY GenderDescription
)
SELECT
    GenderDescription,
    hd.HealthInsurDescription,
    COUNT(hd.HealthInsurDescription) AS COUNT,
    (COUNT(hd.HealthInsurDescription) * 100.0) / (SELECT TotalCount FROM TotalRespondents 
    WHERE TotalRespondents.GenderDescription = hd.GenderDescription)
    AS MentalHealthPercentage
FROM 
    HealthData1 hd 
GROUP BY
    [HealthInsurDescription], GenderDescription
ORDER BY [HealthInsurDescription], GenderDescription;

----- Personal Doctor Count -----------------------------------------------------------------------------------------------
WITH TotalRespondents AS (
    SELECT 
        COUNT(*) AS TotalCount
    FROM
        HealthData1
)

SELECT
    [PersonalDoctorDescription],
    COUNT([PersonalDoctorDescription]) AS COUNT,
    CAST(ROUND((COUNT([PersonalDoctorDescription]) * 100.0) / 
    (SELECT TotalCount FROM TotalRespondents), 2) AS DECIMAL(5, 2))
    AS PersonalDoctorPercentage
FROM 
    HealthData1
GROUP BY
   [PersonalDoctorDescription]
ORDER BY 
    [PersonalDoctorDescription];

--------- Personal doctor and General Health

WITH TotalGeneralHealth AS (
    -- Calculate the total number of people for each general health category
    SELECT 
        GeneralHealthDescription, 
        COUNT(*) AS TotalCount
    FROM 
        HealthData1
    GROUP BY 
        GeneralHealthDescription
)

SELECT
    hd.GeneralHealthDescription,
    hd.PersonalDoctorDescription,
    COUNT(hd.PersonalDoctorDescription) AS Count,
    (COUNT(hd.PersonalDoctorDescription) * 100.0) / 
    (SELECT TotalCount FROM TotalGeneralHealth 
     WHERE TotalGeneralHealth.GeneralHealthDescription = hd.GeneralHealthDescription) AS Percentage
FROM 
    HealthData1 hd
GROUP BY 
    hd.GeneralHealthDescription, hd.PersonalDoctorDescription
ORDER BY 
    hd.GeneralHealthDescription, hd.PersonalDoctorDescription;



------ Medical Cost

WITH TotalRespondents AS (
    SELECT 
        COUNT(*) AS TotalCount
    FROM
        HealthData1
)

SELECT
    [MedCostDescription],
    COUNT([MedCostDescription]) AS COUNT,
    CAST(ROUND((COUNT([MedCostDescription]) * 100.0) / 
    (SELECT TotalCount FROM TotalRespondents), 2) AS DECIMAL(5, 2))
    AS MedicalCostPercentage
FROM 
    HealthData1
GROUP BY
   [MedCostDescription]
ORDER BY 
    [MedCostDescription];


---------- Creating a New Table

CREATE TABLE CleanedColumns (
    State FLOAT,
    Year FLOAT,
    DISPCODE FLOAT,
    SEQNO FLOAT,
    Gender FLOAT,
    GenderDescription VARCHAR(50),
    GeneralHealth INT,
    GeneralHealthDescription VARCHAR(50),
    PhyHealth INT,
    PhysicalHealthDescription VARCHAR(50),
    MenHealth FLOAT,
    MentalHealthDescription VARCHAR(50),
    PoorHealth FLOAT,
    PoorHealthDescription VARCHAR(50),
    HealthInsur FLOAT,
    HealthInsurDescription VARCHAR(50),
    PersonalDoctor FLOAT,
    PersonalDoctorDescription VARCHAR(50),
    MedCost FLOAT,
    MedCostDescription VARCHAR(50),
);

INSERT INTO CleanedColumns (State, Year, DISPCODE, SEQNO, Gender, GenderDescription, GeneralHealth, GeneralHealthDescription,
PhyHealth, PhysicalHealthDescription, MenHealth, MentalHealthDescription, PoorHealth, PoorHealthDescription,
HealthInsur,  HealthInsurDescription, PersonalDoctor, PersonalDoctorDescription, MedCost, MedCostDescription)
SELECT State, Year, DISPCODE, SEQNO, Gender, GenderDescription, GeneralHealth, GeneralHealthDescription,
PhyHealth, PhysicalHealthDescription, MenHealth, MentalHealthDescription, PoorHealth, PoorHealthDescription,
HealthInsur,  HealthInsurDescription, PersonalDoctor, PersonalDoctorDescription, MedCost, MedCostDescription
FROM HealthData1;

CREATE TABLE MiniHealthData (
    State FLOAT,
    Year FLOAT,
    DISPCODE FLOAT,
    SEQNO FLOAT,
    Gender FLOAT,
    GeneralHealth INT,
    PhyHealth INT,
    MenHealth FLOAT,
    PoorHealth FLOAT,
    HealthInsur FLOAT,
    PersonalDoctor FLOAT,
    MedCost FLOAT,
);

INSERT INTO MiniHealthData (State, Year, DISPCODE, SEQNO, Gender, GeneralHealth,
PhyHealth, MenHealth, PoorHealth, HealthInsur, PersonalDoctor,  MedCost)
SELECT State, Year, DISPCODE, SEQNO, Gender, GeneralHealth,
PhyHealth, MenHealth, PoorHealth, HealthInsur, PersonalDoctor,  MedCost
FROM HealthData1;

SELECT *
FROM MiniHealthData