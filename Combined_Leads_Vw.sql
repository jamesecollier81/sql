select
    t1.*,
    t2.field as ld_updated_field,
    t2.newvalue as ld_newvalue,
    t2.oldvalue as ld_oldvalue
from
    (
        select
            t1.id,
            'SalesForce' as source_system,
            t1.first_name,
            t1.last_name,
            t1.email,
            t1.mobile_phone,
            '' as home_phone,
            '' as work_phone,
            t1.street,
            lower(t1.city) as city,
            t2.mapped_state as state,
            t1.zip,
            left(t1.zip, 5) as trim_zip,
            t1.country,
            t1.company_name,
            t1.employee_count,
            t1.industry,
            t1.domain,
            '' as customer_crm,
            '' as company_revenue,
            '' as purchasing_dept,
            t1.updated_date
        from
            leads_db.sfdc_limited t1
            left join leads_db.leads_state_mapping t2 on lower(t1.state) = t2.state
        UNION
            DISTINCT
        select
            t3.id,
            t3.source_system,
            t3.first_name,
            t3.last_name,
            t3.email,
            t3.mobile_phone,
            t3.home_phone,
            t3.work_phone,
            t3.street,
            lower(t3.city) as city,
            t2.mapped_state as state,
            t3.zip,
            left(t3.zip, 5) as trim_zip,
            t3.country,
            t3.company_name,
            t3.employee_count,
            t3.industry,
            t3.domain,
            t3.customer_crm,
            t3.company_revenue,
            t3.purchasing_dept,
            t3.__updatetime as updated_date
        from
            leads_db.outreach t3
            left join leads_db.leads_state_mapping t2 on lower(t3.state) = t2.state
    ) t1
    left join `leads_db.vw_lead_history` t2 on t1.id = t2.leadid;
