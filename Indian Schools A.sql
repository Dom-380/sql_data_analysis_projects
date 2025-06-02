-- Data Setup:

-- Creating Table:
CREATE TABLE placement 
	(ID integer, -- Serial number
	gender varchar(1), -- Gender
	ssc_p numeric(4,2), -- Secondary Ed Percentage
	ssc_b varchar(15), -- Which Board of Education
	hsc_p numeric(4,2), -- Higher Secondary Ed Percentage
	hsc_b varchar(15), -- Board of Education or Higher SE
	hsc_s varchar(15), -- Specialization in Higher Secondary Ed
	degree_p numeric(4,2), -- Degree Percentage
	degree_t varchar(20), -- Undergrad Degree Type
	workex varchar(3), -- Work Experience
	etest_p numeric(4,2), -- Employability test
	specialization varchar(10), -- Specialisiation in MBA
	mba_p numeric(4,2), -- MBA Percentage Score
	status varchar(15), -- Placed in job or not
	salary integer); -- Salary of job offer


COPY placement
FROM '/Users/Shared/Placement_Data_Full_Class.csv'
WITH(FORMAT CSV, HEADER);

-- Printing table for reference:
SELECT * FROM placement; 

-- Questions: 

/* 1. What is the average total exam score across the five exams/grades? What is the correlation between
the degree percentage and the MBA percentage? */

-- Calculating the average total exam score across the five exams
SELECT 
    (AVG(ssc_p) + AVG(hsc_p) + AVG(degree_p) + AVG(etest_p) + AVG(mba_p)) / 5 AS avg_exam_score
FROM placement; -- Answer: 66.88

-- Correlation between degree percentage and MBA percentage
SELECT CORR(degree_p, mba_p) AS correlation_degree_mba
FROM placement; -- Answer: 0.4024

/* Answer: The average score across the five exams is 66.88, indicating a generally moderate 
performance level among students. There is a 40.24% positive correlation between degree percentage 
and MBA percentage, suggesting that students who perform well in their undergraduate degree tend to 
also score higher in their MBA, though the relationship is moderate. */

/* 2. Does having work experience give you a bigger advantage for the employability exam or in the MBA
program grades? */

-- Average employability and MBA scores by work experience
SELECT workex,
       AVG(etest_p) AS avg_employability_score,
       AVG(mba_p) AS avg_mba_score
FROM placement
GROUP BY workex;

/* Answer: People with work experience tend to have slightly higher average scores in both the 
employability test (by approximately 1.58 points) and the MBA program (by approximately 2.07 points) 
compared to those without work experience. This suggests that having work experience provides a small 
advantage in both areas, with a more noticeable impact on MBA grades than on employability test scores. 
However, the difference is small and may not indicate a significant advantage. */

/* 3. What is the expect change in wages for a 1 point change in the employability test (e_test)? Is it
significant? */

-- Regression analysis for salary based on e_test score
SELECT REGR_SLOPE(salary, etest_p) AS wage_change_per_point,
       REGR_R2(salary, etest_p) AS r_squared
FROM placement;

/* Answer: A 1-point increase in the employability test score is associated with an expected salary 
increase of approximately 1213.76. However, this relationship is weak, as the employability test score 
only explains about 3.18% of the variation in salary. Therefore, while there is a positive effect, 
it is likely not a major factor in determining wages. This low r-squared indicates a weak relationship, 
meaning the employability test score alone is not a strong predictor of salary. */


/* 4. Is there a gender wage gap in this data? Could it be MBA program grades driving it? Specialty choice? */

-- Average salary by gender
SELECT gender, AVG(salary) AS avg_salary
FROM placement
GROUP BY gender;

-- Correlation between salary and MBA percentage
SELECT CORR(salary, mba_p) AS correlation_salary_mba
FROM placement;

-- Average salary by MBA specialization
SELECT specialization, AVG(salary) AS avg_salary
FROM placement
GROUP BY specialization;

/* Answer: The data shows a gender wage gap, with males earning, on average, about 31,618 more than 
females. However, the correlation between MBA percentage and salary is weak (0.175), indicating that 
MBA grades are not a major factor in determining salaries. Additionally, MBA specialization does appear 
to impact salary, with Marketing & Finance specialists earning, on average, about 28,475 more than 
Marketing & HR specialists. This suggests that while there is a gender wage gap, it may be partially 
influenced by specialization choices, as Marketing & Finance specialization aligns with higher 
salaries across both genders. */

/* 5. What was the average MBA grade for those who were placed vs. those who were not? */

-- Average MBA grade based on placement status
SELECT status, AVG(mba_p) AS avg_mba_score
FROM placement
GROUP BY status;

/* Answer: The data shows that students who were placed in jobs have a slightly higher average MBA grade (62.58)
compared to those who were not placed (61.61). This suggests that a higher MBA grade may offer a small 
advantage in securing placement. However, the difference of approximately 0.97 points is minimal, 
indicating that MBA grades alone are not a significant factor in determining placement outcomes. */

/* 6. How much is work experience “worth” in terms of salary. Is this difference significant? */

-- Average salary by work experience
SELECT workex, AVG(salary) AS avg_salary
FROM placement
GROUP BY workex;

-- Regression to test significance of work experience on salary
SELECT REGR_SLOPE(salary, CASE WHEN workex = 'Yes' THEN 1 ELSE 0 END) AS experience_salary_change,
       REGR_R2(salary, CASE WHEN workex = 'Yes' THEN 1 ELSE 0 END) AS r_squared
FROM placement;

/* Answer: The data shows that individuals with work experience tend to earn about 25,742 more on 
average than those without work experience, suggesting that work experience has a positive impact on 
salary. However, the low R-squared value (1.87%), suggests that only about 1.87% of the variation in 
salary can be explained by work experience alone - indicating that work experience is only a minor 
factor in explaining salary variations, meaning other factors likely play a much larger role in 
determining salary. */ 