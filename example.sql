--- get all adsh (accession numbers) for a given company from the sub table
SELECT DISTINCT(adsh) FROM sub WHERE name == 'MICROSOFT CORP' ORDER BY adsh;


-- get income statement for adsh
SELECT * FROM pre WHERE stmt = 'IS' AND adsh = '0000950170-23-014423' ORDER BY line;

-- get first 'Revenues' tag from num table
WITH RankedRows AS (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY ddate ORDER BY rowid) AS rn
    FROM num WHERE  adsh in (SELECT DISTINCT(adsh) FROM sub WHERE name == 'MICROSOFT CORP') and qtrs = 1  AND dimh = '0x00000000' AND tag IN ('Revenues', 'SalesRevenueNet', 'SalesRevenueNetAbstract', 'RevenueFromContractWithCustomerExcludingAssessedTax') 
)
SELECT *
FROM RankedRows where rn = 1
order by ddate;