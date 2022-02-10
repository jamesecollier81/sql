select
    main.id,
    main.source_system,
    main.first_name,
    main.last_name,
    main.email,
    main.mobile_phone,
    main.home_phone,
    main.work_phone,
    main.street,
    main.city,
    main.state,
    main.zip,
    main.country,
    main.company_name,
    main.employee_count,
    main.industry,
    main.domain,
    main.customer_crm,
    main.company_revenue,
    main.purchasing_dept,
    main.__updatetime as updated_date,
    main.stage
from
    `leads_db.outreach` as main
    left outer join `leads_db.outreach_updated` as upd on main.id = upd.id
where
    upd.id IS NULL
union ALL
select
    upd.id,
    upd.source_system,
    upd.first_name,
    upd.last_name,
    upd.email,
    upd.mobile_phone,
    upd.home_phone,
    upd.work_phone,
    upd.street,
    upd.city,
    upd.state,
    upd.zip,
    upd.country,
    upd.company_name,
    upd.employee_count,
    upd.industry,
    upd.domain,
    upd.customer_crm,
    upd.company_revenue,
    upd.purchasing_dept,
    upd.__updatetime as updated_date,
    upd.stage
from
    `leads_db.outreach_updated` as upd
    left outer join `leads_db.outreach` as main on upd.id = main.id
where
    main.id IS NOT NULL