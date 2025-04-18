
-- Write a query to report the number of vaccinations each animal has recieved. Include animals that were never vaccinated.
-- Exclude rabbits, rabies vaccines, and animals that were last vaccinated on or after October first, 2019.
-- The report should show the animals name, species, primary color, breed, and the number of vaccinations.
-- Use the correct logical join type and force order if needed.
-- Use the correct logical group by expressions.

SELECT  A.Species,
		A.Name,
		MAX(A.Primary_color) AS Primary_color, -- Dummy Aggregate
		MAX(A.Breed) AS Breed, -- Dummy Aggregate
		COUNT(V.Vaccine) As Num_Vaccinations
FROM 	Animals AS A
	 	LEFT OUTER JOIN
		Vaccinations As V
		ON V.Name = A.Name AND V.Species = A.Species
WHERE	A.species <> 'Rabbit' AND (V.vaccine <> 'Rabies' OR V.vaccine IS NULL)
GROUP BY A.Species, A.Name
HAVING  MAX(V.vaccination_time) < '20191001' or MAX(V.Vaccination_time) IS NULL
ORDER BY A.Species, A.Name;
