DROP VIEW IF EXISTS zaf.vw_sampled_centroids;

CREATE VIEW zaf.vw_sampled_centroids AS
	SELECT
		village_code,
		the_geom,
		village_name,
		main_place_name,
		main_place_code,
		municipality_name,
		municipality_code,
		district_name,
		district_code,
		province_name,
		province_code,
		centroid,
		SUBSTRING(centroid from (POSITION('(' in centroid) + 1) for 8) || ', ' ||
			SUBSTRING(centroid from (POSITION(' ' in centroid) + 1) for 9) AS approx_coord,
		survey,
		sampled_date
	FROM (
			SELECT
				ST_Centroid(ST_Union(the_geom)) AS the_geom,
				ST_AsText(ST_Transform(ST_SetSRID(ST_Centroid(ST_Union(the_geom)),201100),4326)) AS centroid,
				village_name,
				village_code,
				main_place_name,
				main_place_code,
				municipality_name,
				municipality_code,
				district_name,
				district_code,
				province_name,
				province_code,
				survey,
				sampled_date
			FROM (
				SELECT
					village_code,
					village_name,
					main_place_code,
					main_place_name,
					municipality_code,
					municipality_name,
					district_code,
					district_name,
					province_code,
					province_name,
					sampled_date,
					survey,
					ST_Centroid(the_geom) AS the_geom
				FROM
					zaf.vw_sampled_villages
			) AS g
			GROUP BY
				village_code,
				village_name,
				main_place_name,
				main_place_code,
				municipality_name,
				municipality_code,
				district_name,
				district_code,
				province_name,
				province_code,
				survey,
				sampled_date
		) AS h
	ORDER BY
		village_code
;

SELECT
	lz_code || ': ' || lz_name || ' (' || lz_abbrev || ')' AS lz,
	r.survey,
	r.sampled_date,
	province_name,
	province_code,
	district_name,
	district_code,
	municipality_name,
	municipality_code,
	main_place_name,
	main_place_code,
	village_name,
	r.village_code,
	pop,
	num_sas,
	SUBSTRING(coord from (POSITION(' ' in coord) + 1) for 8) || ', ' ||
		SUBSTRING(coord from (POSITION('(' in coord) + 1) for 7) AS approx_coord,
	r.survey || ' - ' || village_name || ': ' || SUBSTRING(coord from (POSITION(' ' in coord) + 1) for 8) || ', ' ||
		SUBSTRING(coord from (POSITION('(' in coord) + 1) for 7) AS village_and_coord
FROM
	(
		SELECT
			village_code,
			survey,
			sampled_date,
			COUNT(k.sa_code) AS num_sas,
			SUM(total) AS pop
		FROM
			zaf.tbl_sampled_villages AS i,
			zaf.tbl_pop_agegender_12y AS j,
			zaf.demog_sas AS k
		WHERE
				k.sa_code = j.sa_code
			AND
				i.village_code = k.sp_code
		GROUP BY
			village_code,
			survey,
			sampled_date
	) AS l,
	(
		SELECT
			village_code,
			m.lz_code,
			lz_name,
			lz_abbrev,
			sampled_date
		FROM
			zaf.tbl_sampled_villages AS m,
			zaf.tbl_livezones_list AS n
		WHERE
			m.lz_code = n.lz_code
	) AS p,
	(
		SELECT
			village_code,
			village_name,
			main_place_code,
			main_place_name,
			municipality_code,
			municipality_name,
			district_code,
			district_name,
			province_code,
			province_name,
			survey,
			sampled_date,
			ST_Centroid(ST_Union(the_geom)) AS centroid_geom,
			ST_AsText(ST_Transform(ST_SetSRID(ST_Centroid(ST_Union(the_geom)),201100),4326)) AS coord
		FROM
			(
				SELECT
					village_code,
					village_name,
					main_place_code,
					main_place_name,
					municipality_code,
					municipality_name,
					district_code,
					district_name,
					province_code,
					province_name,
					sampled_date,
					survey,
					ST_Centroid(the_geom) AS the_geom
				FROM
					zaf.vw_sampled_villages
			) AS q
/*		WHERE
				p.village_code = q.village_code
			AND
				p.sampled_date = q.sampled_date*/
		GROUP BY
			village_code,
			village_name,
			main_place_code,
			main_place_name,
			municipality_code,
			municipality_name,
			district_code,
			district_name,
			province_code,
			province_name,
			survey,
			sampled_date
	) AS r
WHERE
		p.village_code = l.village_code
	AND
		p.village_code = r.village_code
	AND
		p.sampled_date = r.sampled_date
ORDER BY
	province_name,
	lz_code,
	district_name,
	municipality_name,
	main_place_name,
	village_name
;
