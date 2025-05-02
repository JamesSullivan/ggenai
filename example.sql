--- get all adsh (accession numbers) for a given company from the sub table
SELECT DISTINCT(adsh) FROM sub WHERE name = 'MICROSOFT CORP' ORDER BY adsh;


-- get income statement for adsh
SELECT * FROM pre WHERE stmt = 'IS' AND adsh = '0000950170-23-014423' ORDER BY line;

-- get first 'Revenues' tag from num table
WITH RankedRows AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY ddate ORDER BY rowid) AS rn
    FROM num WHERE  adsh in (SELECT DISTINCT(adsh) FROM sub WHERE name = 'MICROSOFT CORP') and qtrs = 1  AND dimh = '0x00000000' AND tag IN ('Revenues', 'SalesRevenueNet', 'SalesRevenueNetAbstract', 'RevenueFromContractWithCustomerExcludingAssessedTax') 
)
SELECT *
FROM RankedRows where rn = 1
order by ddate;


WITH adsh_t AS (
    SELECT DISTINCT adsh FROM sub WHERE name = 'NVIDIA CORP'
),
tag_t AS (
    SELECT DISTINCT tag 
    FROM pre 
    WHERE adsh IN (SELECT adsh FROM adsh_t) 
      AND plabel = 'Revenue'
      AND tag not like '%Acquisitions%'
),
RankedRows AS (
    SELECT adsh, tag, version, ddate, uom, value, ROUND(AVG(value) OVER (PARTITION BY ddate), 0) AS avg_value, ROW_NUMBER() OVER (PARTITION BY ddate ORDER BY rowid) AS rn
    FROM num 
    WHERE adsh IN (SELECT adsh FROM adsh_t) 
      AND qtrs = 4  
      AND dimh = '0x00000000' 
      AND tag IN (SELECT tag FROM tag_t)
)
SELECT *
FROM RankedRows 
ORDER BY ddate;


WITH adsh_t AS (
    SELECT DISTINCT adsh FROM sub WHERE name = 'MICROSOFT CORP'
),
tag_t AS (
    SELECT DISTINCT tag 
    FROM pre 
    WHERE adsh IN (SELECT adsh FROM adsh_t) 
      AND plabel = 'Revenue'
      AND tag not like '%Acquisitions%'
),
RankedRows AS (
    SELECT ddate, AVG(value) AS avg_value
    FROM num 
    WHERE adsh IN (SELECT adsh FROM adsh_t) 
      AND qtrs = 4  
      AND dimh = '0x00000000' 
      AND tag IN (SELECT tag FROM tag_t)
    GROUP BY ddate
) 
SELECT *
FROM RankedRows 
ORDER BY ddate;