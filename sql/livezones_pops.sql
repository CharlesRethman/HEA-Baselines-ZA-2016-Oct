COPY
	(
		SELECT
			f.pr_name,
			pr_code,
			dc_name,
			f.dc_code,
			mn_name,
			f.mn_code,
			mp_name,
			mp_code,
			sp_name,
			sp_code,
			f.sa_code AS sa_code,
			total_m + total_f AS pop_size,
			round((total_m + total_f)::numeric * i.pop_c / m.pop_y, 0) AS pop_curr,
			round(pop_mn_y::numeric * i.pop_c / m.pop_y, 0) AS mn_pop_curr,
			i.pop_c AS dc_pop_curr,
			pr_pop_curr,
			f.lz_code AS lz_code,
			lz_name,
			lz_abbrev,
			f.lz_code || ': ' || lz_name || ' (' || lz_abbrev || ')' AS lz
		FROM
			zaf.demog_sas AS f,
			zaf.tbl_pop_agegender_05y AS g,
			zaf.tbl_livezones_list AS h,
			(
				SELECT dc_code, sum(pop) AS pop_c
				FROM zaf.tbl_pop_proj, zaf.admin3_dists
				WHERE
						year_mid = 2016
					AND
						zaf.admin3_dists.dc_mdb_code = zaf.tbl_pop_proj.dc_mdb_code
				GROUP BY dc_code
			) AS i,
			(
				SELECT dc_code, sum(total_m + total_f) AS pop_y
				FROM zaf.tbl_pop_agegender_05y AS j, zaf.demog_sas AS k
				WHERE j.sa_code = k.sa_code
				GROUP BY dc_code
			) AS m,
			(
				SELECT mn_code, sum(total_m + total_f) AS pop_mn_y
				FROM zaf.tbl_pop_agegender_05y AS n, zaf.demog_sas AS p
				WHERE n.sa_code = p.sa_code
				GROUP BY mn_code
			) AS q,
			(
				SELECT pr_name, sum(pop) AS pr_pop_curr
				FROM zaf.tbl_pop_proj, zaf.admin3_dists
				WHERE
						year_mid = 2016
					AND
						zaf.admin3_dists.dc_mdb_code = zaf.tbl_pop_proj.dc_mdb_code
				GROUP BY pr_name
			) AS r
		WHERE
				f.sa_code = g.sa_code
			AND
				f.lz_code = h.lz_code
			AND
				f.dc_code = i.dc_code
			AND
				f.dc_code = m.dc_code
			AND
				f.mn_code = q.mn_code
			AND
				f.pr_name = r.pr_name
			AND
				(f.lz_code = 59101 OR f.lz_code = 59104 OR f.lz_code = 59201 OR f.lz_code = 59205 OR f.lz_code = 59303)
		ORDER BY
			f.pr_name,
			dc_name,
			mn_name,
			mp_name,
			sp_name,
			sa_code
	)
TO
	'/Users/Charles/Documents/hea_baselines/south_africa/baselines_surveys/2016_lp_mp/sampling/livezones_pops.csv'
WITH (
	FORMAT CSV, DELIMITER ',', HEADER TRUE
)
;
