INSERT INTO zaf.tbl_sampled_villages (
	village_name,
	village_code,
--	main_place_name,
--	main_place_code,
--	municipality_name,
--	municipality_code,
--	municipality_mdb_c,
--	district_name,
--	district_code,
--	district_mdb_c,
--	province_name,
--	province_code,
--	province_mdb_c,
	lz_code, 
	survey,
	sampled_date
	)
	SELECT DISTINCT
		sp_name,
		sp_code,
--		mp_name,
--		mp_code,
--		mn_name,
--		mn_code,
--		mn_mdb_c,
--		dc_name,
--		dc_code,
--		dc_mdb_c,
--		pr_name,
--		pr_code,
--		pr_mdb_c,
		lz_code,
		'hea' AS survey,
		current_date AS sampled_date
	FROM
		zaf.demog_sas 
	WHERE 
			lz_code = 59101
		AND 
			(sp_code = 877088001 OR sp_code = 963008002 OR sp_code = 877099001 OR sp_code = 876043001 OR sp_code = 877120001 OR sp_code = 876042001 OR sp_code = 877083001 OR sp_code = 877033001 OR sp_code = 874026001 OR sp_code = 877064001 OR sp_code = 874014001 OR sp_code = 876033001) 
;
