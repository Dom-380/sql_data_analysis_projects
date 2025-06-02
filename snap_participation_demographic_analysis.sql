--SNAP participation
SELECT *
FROM counties AS a
JOIN counties_2000 AS b
ON a.state_fips = b.state_fips 
AND a.county_fips = b.county_fips

JOIN county_snap AS c
ON a.state_fips = c.state_fips
AND a.county_fips = c.county_fips;;


--1. How many people receive SNAP benefits in 2000? In 2010? 

--ANSWER: In 2000 there were, 34,129,848 people recieved SNAP and in 2010 there were 87,437,628 people.
SELECT SUM(c.snap_2010) AS total_snap_2010,
       SUM(c.snap_2000) AS total_snap_2000
FROM county_snap AS c;

--1. What proportion of the population receives them in each time period?

--ANSWER: In 2000 it appears that 6% of the populace is recieving SNAP which increases to 14% in 2010
SELECT ROUND(SUM(c.snap_2010) / SUM(a.totalpop),2) AS proportion_snap_2010,
       ROUND(SUM(c.snap_2000) / SUM(b.totalpop),2) AS proportion_snap_2000
FROM counties AS a
JOIN counties_2000 AS b
ON a.state_fips = b.state_fips 
AND a.county_fips = b.county_fips
JOIN county_snap AS c
ON a.state_fips = c.state_fips
AND a.county_fips = c.county_fips;

--2. Which states and counties have the highest proportion of SNAP participants?

--COUNTIES ANSWERS-------------------------------------------------------------
--ANSWER 2010: It seems as though the top 3 counties recieving SNAP are Shannon (SD), Todd (SD) and Wade Hampton (AK)
SELECT a.geo_name, a.state_us_abbreviation, ROUND(SUM(c.snap_2010) / SUM(a.totalpop),2) AS proportion_snap_2010,
       ROUND(SUM(c.snap_2000) / SUM(b.totalpop),2) AS proportion_snap_2000
FROM counties AS a
JOIN counties_2000 AS b
ON a.state_fips = b.state_fips 
AND a.county_fips = b.county_fips
JOIN county_snap AS c
ON a.state_fips = c.state_fips
AND a.county_fips = c.county_fips
WHERE c.snap_2010 IS NOT NULL
AND c.snap_2000 IS NOT NULL
GROUP BY a.geo_name, a.state_us_abbreviation
ORDER BY proportion_snap_2010 DESC, proportion_snap_2000 DESC
LIMIT 3;

--ANSWER 2000: The top 3 counties for SNAP are, Owsely (KY), Shannon (SD) and Wilcox(AL)
SELECT a.geo_name, a.state_us_abbreviation, 
		ROUND(SUM(c.snap_2000) / SUM(b.totalpop),2) AS proportion_snap_2000,
		ROUND(SUM(c.snap_2010) / SUM(a.totalpop),2) AS proportion_snap_2010
FROM counties AS a
JOIN counties_2000 AS b
ON a.state_fips = b.state_fips 
AND a.county_fips = b.county_fips
JOIN county_snap AS c
ON a.state_fips = c.state_fips
AND a.county_fips = c.county_fips
WHERE c.snap_2010 IS NOT NULL
AND c.snap_2000 IS NOT NULL
GROUP BY a.geo_name, a.state_us_abbreviation
ORDER BY proportion_snap_2000 DESC, proportion_snap_2010 DESC
LIMIT 3;

--STATE ANSWERS-------------------------------------------------------------------
--ANSWER 2010: The Top three states for SNAP are Washtington DC (DC), Mississippi (MS), and New Mexico (NM) 
SELECT a.state_us_abbreviation,
		ROUND(SUM(c.snap_2010) / SUM(a.totalpop),2) AS proportion_snap_2010,
		ROUND(SUM(c.snap_2000) / SUM(b.totalpop),2) AS proportion_snap_2000
FROM counties AS a
JOIN counties_2000 AS b
ON a.state_fips = b.state_fips 
AND a.county_fips = b.county_fips
JOIN county_snap AS c
ON a.state_fips = c.state_fips
AND a.county_fips = c.county_fips
WHERE c.snap_2010 IS NOT NULL
AND c.snap_2000 IS NOT NULL
GROUP BY a.state_us_abbreviation
ORDER BY proportion_snap_2010 DESC, proportion_snap_2000 DESC
LIMIT 3;

--ANSWER 2000: Top 3 states are Washington DC (DC), West Virginia (WV), and Louisiana (LA)
SELECT a.state_us_abbreviation,
		ROUND(SUM(c.snap_2000) / SUM(b.totalpop),2) AS proportion_snap_2000,
		ROUND(SUM(c.snap_2010) / SUM(a.totalpop),2) AS proportion_snap_2010
FROM counties AS a
JOIN counties_2000 AS b
ON a.state_fips = b.state_fips 
AND a.county_fips = b.county_fips
JOIN county_snap AS c
ON a.state_fips = c.state_fips
AND a.county_fips = c.county_fips
WHERE c.snap_2010 IS NOT NULL
AND c.snap_2000 IS NOT NULL
GROUP BY a.state_us_abbreviation
ORDER BY proportion_snap_2000 DESC
LIMIT 3;

--3. Did any counties see a disconnect between population growth and SNAP participation growth? 

--ANSWER: If I run the query in DESC order it appears both the percentage population and snap recipient population
--increase, however, when in ASC order it seems as though several counties such as St. Bernard Parish (LA) and
--Sheridan County (ND) see a signifianct increase in SNAP recipients despite population decreases.
SELECT a.geo_name, a.state_us_abbreviation,
       (a.totalpop - b.totalpop) AS abs_pop_change,
	   (c.snap_2010 - c.snap_2000) AS abs_snap_change,
       ROUND(((a.totalpop::numeric - b.totalpop::numeric) / b.totalpop::numeric) * 100, 2) AS perc_pop_growth,
       ROUND(((c.snap_2010::numeric - c.snap_2000::numeric) / c.snap_2000::numeric) * 100, 2) AS snap_perc_growth
FROM counties AS a
JOIN counties_2000 AS b
ON a.state_fips = b.state_fips 
AND a.county_fips = b.county_fips
JOIN county_snap AS c
ON a.state_fips = c.state_fips
AND a.county_fips = c.county_fips
WHERE b.totalpop > 0
AND c.snap_2000 > 0
ORDER BY perc_pop_growth ASC;

--4. Does SNAP participation track more closely with overall population growth or non-white population growth?

--ANSWER: I'm seeing an overall greater increase of the white population's use of SNAP in relation to their
--percentage pop growth versus non-white. Overall as the percentage of population increases so do the SNAP
--recipient percentage ammount. It seems that the non_white population percentages are closer to their SNAP 
--usage percentage (example: 95.15 non white pop increase and 105 SNAP increase). The total pop has more drastic changes
--in percentages (exalmple: 110 pop increase and 372 SNAP increase). This could be due to the fact that the
--non-white populace is factored into the total pop as well as the white populace. 

SELECT a.geo_name, a.state_us_abbreviation,

	   -- White population change percentage
       ROUND(((a.white_1::numeric - b.white_1::numeric) / b.white_1::numeric) * 100, 2) AS white_perc_change,	

       
	   -- Non-white population growth percentage
       ROUND(((a.totalpop - a.white_1)::numeric - (b.totalpop - b.white_1)::numeric) / (b.totalpop - b.white_1)::numeric * 100, 2) AS perc_non_white_change,

	   -- Overall population growth percentage
       ROUND(((a.totalpop::numeric - b.totalpop::numeric) / b.totalpop::numeric) * 100, 2) AS perc_pop_change,
	   
	   
	   -- Ratio of SNAP to White Population change from 2000 to 2010
       ROUND(((c.snap_2010::numeric / a.white_1::numeric) - (c.snap_2000::numeric / b.white_1::numeric)) 
             / (c.snap_2000::numeric / b.white_1::numeric) * 100, 2) AS snap_to_white_ratio_change,
	   
       -- Ratio of SNAP to Non-White Population change from 2000 to 2010
       ROUND(((c.snap_2010::numeric / (a.totalpop - a.white_1)::numeric) - (c.snap_2000::numeric / (b.totalpop - b.white_1)::numeric)) 
             / (c.snap_2000::numeric / (b.totalpop - b.white_1)::numeric) * 100, 2) AS snap_to_non_white_ratio_change,

       -- Ratio of SNAP to Total Population change from 2000 to 2010
       ROUND(((c.snap_2010::numeric / a.totalpop::numeric) - (c.snap_2000::numeric / b.totalpop::numeric)) 
             / (c.snap_2000::numeric / b.totalpop::numeric) * 100, 2) AS snap_to_total_pop_ratio_change

FROM counties AS a
JOIN counties_2000 AS b
ON a.state_fips = b.state_fips 
AND a.county_fips = b.county_fips
JOIN county_snap AS c
ON a.state_fips = c.state_fips
AND a.county_fips = c.county_fips
WHERE b.totalpop > 0
AND c.snap_2000 > 0
ORDER BY perc_pop_change DESC;

--5. Is SNAP participation higher in states where there is water scarcity?

--ANSWER: A reoccuring pattern in the, top ten counties for water scarcity, seems to show that the total
--number of SNAP recipients is floatingin the 3-4k range. 
SELECT a.geo_name, a.state_us_abbreviation, 
	   a.totalpop, a.area_water,

	   --SNAP particpants 2010
	   c.snap_2010 as total_snap_2010,

	   --Water per person measurement
	   ROUND((a.area_water::numeric / a.totalpop::numeric), 2) AS water_per_person,

	   --Snap percentage growth 2000 to 2010
	   ROUND(((c.snap_2010::numeric - c.snap_2000::numeric) / c.snap_2000::numeric) * 100, 2) AS snap_perc_growth
       
FROM counties AS a
JOIN counties_2000 AS b
ON a.state_fips = b.state_fips 
AND a.county_fips = b.county_fips
JOIN county_snap AS c
ON a.state_fips = c.state_fips
AND a.county_fips = c.county_fips
WHERE b.totalpop > 0
AND c.snap_2000 > 0
ORDER BY water_per_person ASC
LIMIT 10;

--ANSWER: The top ten counties not suffering from water scarcity seem to have total SNAP recipient numbers
--hovering around the 200 range with a few outliers. 
SELECT a.geo_name, a.state_us_abbreviation, 
	   a.totalpop, a.area_water,

	   --SNAP particpants 2010
	   c.snap_2010 as total_snap_2010,

	   --Water per person measurement
	   ROUND((a.area_water::numeric / a.totalpop::numeric), 2) AS water_per_person,

	   --Snap percentage growth 2000 to 2010
	   ROUND(((c.snap_2010::numeric - c.snap_2000::numeric) / c.snap_2000::numeric) * 100, 2) AS snap_perc_growth
       
FROM counties AS a
JOIN counties_2000 AS b
ON a.state_fips = b.state_fips 
AND a.county_fips = b.county_fips
JOIN county_snap AS c
ON a.state_fips = c.state_fips
AND a.county_fips = c.county_fips
WHERE b.totalpop > 0
AND c.snap_2000 > 0
ORDER BY water_per_person DESC
LIMIT 10;

--OVERALL ANSWER: I used a ratio of area water divided by total pop to calculate a water per person
--column. I used this to check how the bottom/top 10 counties faired in terms of their total SNAP
--participation. It seems as though water scarcity does indeed correlate with more SNAP recipients, but
--as to whether this is causitive, that is not conclusive. 
