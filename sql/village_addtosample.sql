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
		'hea' AS survey,
		date '2016-10-04' AS sampled_date
	FROM
		zaf.demog_sas
	WHERE
			lz_code IN (
				VALUES (59101), (59104), (59201), (59205), (59303)
			)
		AND
			sp_code IN (
				VALUES (862005001), (863005003)
			)
;
