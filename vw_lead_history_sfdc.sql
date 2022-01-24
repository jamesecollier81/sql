WITH added_row_number as (
    select
        *,
        row_number() over (
            partition by leadid
            order by
                leadid DESC
        ) as row_number
    from(
            select
                t1.leadid,
                t1.field,
                t1.newvalue,
                t1.oldvalue
            from
                (
                    select
                        leadid,
                        field,
                        newvalue,
                        oldvalue,
                        createddate
                    from
                        `leads_db.salesforce_leadhistory`
                    where
                        newvalue IS NOT NULL
                    order by
                        1,5
                ) t1
                join (
                    SELECT
                        leadid,
                        min(createddate) as min_create_date
                    FROM
                        `leads_db.salesforce_leadhistory`
                    group by
                        leadid
                ) t2 on t1.leadid = t2.leadid
                AND t1.createddate = t2.min_create_date
            order by
                t1.leadid
        )
)
select
    leadid,
    field,
    newvalue,
    oldvalue
from
    added_row_number
where
    row_number = 1;
