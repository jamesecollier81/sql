SELECT
    *,
    SUM(final_amount) OVER(PARTITION BY team) AS team_final_amount,
    SUM(final_amount) OVER(PARTITION BY team_lead) AS teamlead_final_amount,
    SUM(final_amount) OVER(PARTITION BY manager) AS mgr_final_amount,
    SUM(final_amount) OVER(PARTITION BY director) AS director_final_amount,
    SUM(final_amount) OVER(PARTITION BY rep_name) AS rep_final_amount
FROM
    (
        SELECT
            t3.closed_date,
            t3.final_amount,
            t3.jc_sale_type,
            t3.assigned_sale_type,
            t1.*
        FROM
            (
                SELECT
                    DISTINCT bu,
                    director,
                    manager,
                    team_lead,
                    team,
                    rep_name,
                    sf_table.id,
                    sf_table.approved_quota,
                    SUM(sf_table.approved_quota) OVER(PARTITION BY team) AS team_quota,
                    SUM(sf_table.approved_quota) OVER(PARTITION BY team_lead) AS teamlead_quota,
                    SUM(sf_table.approved_quota) OVER(PARTITION BY manager) AS mgr_quota,
                    SUM(sf_table.approved_quota) OVER(PARTITION BY director) AS director_quota
                FROM
                    `panoply-455-b68e860f73ff.views.vw_mil_quota` qs
                    JOIN (
                        SELECT
                            id,
                            name,
                            MAX(quota__c) AS approved_quota
                        FROM
                            `panoply-455-b68e860f73ff.sfdc.salesforce_user`
                        where
                            isactive = TRUE
                        GROUP BY
                            id,
                            name
                    ) sf_table ON qs.rep_name = sf_table.name
                WHERE
                    rep_name <> ' '
            ) t1
            LEFT JOIN (
                SELECT
                    ownerid,
                    DATE(closedate) AS closed_date,
                    final_amount__c AS final_amount,
                    jumpcrew_sale_type__c AS jc_sale_type,
                    CASE
                        WHEN jumpcrew_sale_type__c = 'JumpCrew' THEN 'Other'
                        WHEN jumpcrew_sale_type__c = 'MBG Digital' THEN 'MBG'
                        WHEN jumpcrew_sale_type__c = 'AHRN' THEN 'AHRN'
                        WHEN jumpcrew_sale_type__c = 'National' THEN 'National'
                        WHEN jumpcrew_sale_type__c = 'MBG JumpStart' THEN 'MBG'
                        WHEN jumpcrew_sale_type__c = 'MBG Publishing' THEN 'MBG'
                        WHEN jumpcrew_sale_type__c = 'Military Contract' THEN 'MBG'
                        ELSE 'Other'
                    END AS assigned_sale_type
                FROM
                    `sfdc.salesforce_opportunity`
                where
                    stagename = 'Closed Won'
                    AND DATE(closedate) > DATE_SUB(
                        DATE_TRUNC(
                            CURRENT_DATE(),
                            MONTH
                        ),
                        INTERVAL 1 DAY
                    )
            ) t3 ON t1.id = t3.ownerid
    );
    
