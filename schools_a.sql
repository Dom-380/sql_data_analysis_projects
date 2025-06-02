--STEP 1: CHAINING
--SETUP CODE: CHAINING DATA SETS BY ZIP AND DBN:
SELECT DISTINCT a.borough, a.zip, b.BOROUGH, c.Postcode, c.dbn, d.DBN
FROM zip AS a
JOIN x2010 AS b
ON a.borough = b.BOROUGH

JOIN x2016 AS c
ON a.zip = c.Postcode

JOIN x2017 AS d
ON c.dbn = d.DBN;

--STEP 2: FIND AVERAGE CLASS SIZE AND RELATE THIS TO GRADUATION/DROPOUT RATES
--CLASS SIZE ARGUMENT:
--It appears as though the average class size is similar across the five boroughs (21-23), with simliar
--ranges of graduates as well (73-79), dropout rates are also fair uniform (9-12)
SELECT a.BOROUGH,
       ROUND(AVG(a.AVERAGE_CLASS_SIZE), 2) AS avg_class_size,
       ROUND(AVG(CAST(d. Total_Grads_cohort AS NUMERIC)), 2) AS avg_graduates,
	   ROUND(AVG(CAST(d. Dropped_Out_cohort AS NUMERIC)), 2) AS avg_dropouts
	   
FROM x2010 AS a
JOIN zip AS b
ON a.BOROUGH = b.borough

JOIN x2016 AS c
ON b.zip = c.Postcode

JOIN x2017 AS d
ON c.dbn = d.DBN

--Filter for null and s values permiating the colum
WHERE d.Total_Grads_cohort IS NOT NULL
AND d. Total_Grads_cohort != 's'

GROUP BY a.BOROUGH;

--STEP 3: MINORITY DATA
--MINORITY DEMOGRAPHIC EXPLORATION:-------------------------------------------------------------
--It seems as though the white populace has a higher overall graduation as well as lower dropout rate
--when compared to the minority populace. 
SELECT a.BOROUGH,
		
	   --MINORITY POPULACE:---------------------------------------------------------------------
       -- Average graduates for minorities
       ROUND(AVG(CASE WHEN d.Demographic_Variable NOT IN ('White', 'Male White', 'Female White') 
       THEN CAST(d.Total_Grads_cohort AS NUMERIC) END), 2) AS avg_minority_grads,
       
       -- Average dropouts for minorities
       ROUND(AVG(CASE WHEN d.Demographic_Variable NOT IN ('White', 'Male White', 'Female White') 
       THEN CAST(d.Dropped_Out_cohort AS NUMERIC) END), 2) AS avg_minority_dropouts,

	   --WHITE POPULACE: ----------------------------------------------------------------------------
       -- Average graduates for the white population
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('White', 'Male White', 'Female White') 
       THEN CAST(d.Total_Grads_cohort AS NUMERIC) END), 2) AS avg_white_grads,
       
       -- Average dropouts for the white population
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('White', 'Male White', 'Female White') 
       THEN CAST(d.Dropped_Out_cohort AS NUMERIC) END), 2) AS avg_white_dropouts

FROM x2010 AS a
JOIN zip AS b
ON a.BOROUGH = b.borough

JOIN x2016 AS c
ON b.zip = c.Postcode

JOIN x2017 AS d
ON c.dbn = d.DBN

-- Filter for valid data in graduation and dropout counts
WHERE d.Total_Grads_cohort IS NOT NULL
AND d.Total_Grads_cohort != 's'
AND d.Dropped_Out_cohort IS NOT NULL
AND d.Dropped_Out_cohort != 's'

GROUP BY a.BOROUGH;


--MINORITY DEMOGRAPHIC EXPLORATION CONTINUED:
--It appears as though asians and multi-racial demographic categories have a higher graduation rate as well
--as a lower drop out rate amongst other racial minorities. 
SELECT a.BOROUGH,
       --ROUND(AVG(a.AVERAGE_CLASS_SIZE), 2) AS avg_class_size,
       
       -- Average number of Asian graduates
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('Asian', 'Male Asian', 'Female Asian')
	   THEN CAST(d.Total_Grads_cohort AS NUMERIC) END), 2) AS avg_asian_graduates,

	   ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('Asian', 'Male Asian', 'Female Asian')
	   THEN CAST(d.Dropped_Out_cohort AS NUMERIC) END), 2) AS avg_asian_dropouts,

       -- Average number of Black graduates
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('Black', 'Male Black', 'Female Black') 
	   THEN CAST(d.Total_Grads_cohort AS NUMERIC) END), 2) AS avg_black_graduates, 

	   -- Average number of Black graduates
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('Black', 'Male Black', 'Female Black') 
	   THEN CAST(d.Dropped_Out_cohort AS NUMERIC) END), 2) AS avg_black_dropouts,

	   -- Average number of Black graduates
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('Hispanic', 'Male Hispanic', 'Female Hispanic') 
	   THEN CAST(d.Total_Grads_cohort AS NUMERIC) END), 2) AS avg_hispanic_graduates, 

	   -- Average number of Black graduates
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('Hispanic', 'Male Hispanic', 'Female Hispanic') 
	   THEN CAST(d.Dropped_Out_cohort AS NUMERIC) END), 2) AS avg_hispanic_dropouts,

	    -- Average number of Black graduates
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('Native American', 'Male Native American', 'Female Native American') 
	   THEN CAST(d.Total_Grads_cohort AS NUMERIC) END), 2) AS avg_NatA_graduates, 

	   -- Average number of Black graduates
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('Native American', 'Male Native American', 'Female Native American') 
	   THEN CAST(d.Dropped_Out_cohort AS NUMERIC) END), 2) AS avg_NatA_dropouts,

	    -- Average number of Black graduates
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('Multi-Racial', 'Male Multi-Racial', 'Female Multi-Racial') 
	   THEN CAST(d.Total_Grads_cohort AS NUMERIC) END), 2) AS avg_MultR_graduates, 

	   -- Average number of Black graduates
       ROUND(AVG(CASE WHEN d.Demographic_Variable IN ('Multi-Racial', 'Male Multi-Racial', 'Female Multi-Racial') 
	   THEN CAST(d.Dropped_Out_cohort AS NUMERIC) END), 2) AS avg_MultR_dropouts


FROM x2010 AS a
JOIN zip AS b
ON a.BOROUGH = b.borough

JOIN x2016 AS c
ON b.zip = c.Postcode

JOIN x2017 AS d
ON c.dbn = d.DBN

-- Filter out null and 's' values
WHERE d.Total_Grads_cohort IS NOT NULL
AND d.Total_Grads_cohort != 's'
AND d.Dropped_Out_cohort IS NOT NULL
AND d.Dropped_Out_cohort != 's'

GROUP BY a.BOROUGH;

EXPLAIN ANALYZE SELECT BOROUGH, SUM(number_of_students_seats_filled)
FROM X2010
GROUP BY BOROUGH;

SELECT *
FROM X2010;
