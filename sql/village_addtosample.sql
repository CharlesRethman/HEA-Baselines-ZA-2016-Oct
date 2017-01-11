INSERT INTO zaf.tbl_sampled_villages (
	village_name,
	village_code,
	lz_code,
	survey,
	sampled_date
	)
	SELECT DISTINCT
		sp_name,
		sp_code,
		lz_code,
-- NB: Place your survey type here as 'hea', 'both' or 'continuum'
		'both' AS survey,
-- NB: Place your required sample date in here in yyyy-mm-dd format!
		date '2016-10-04' AS sampled_date
	FROM
		zaf.demog_sas
	WHERE
			lz_code IN (
				VALUES (59101), (59104), (59201), (59205), (59303)
			)
		AND
			sp_code IN (
-- NB: Place your required sub-place (sp_code) values in here!
				VALUES (984051001), (984062001), (984073001)
			)
;
