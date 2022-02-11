select
    concat('exp_autochk',t1.contact_id) as id,
    'Hubspot' as source_system,
    'experian_autocheck' as instance,
    t2.firstname as first_name,
    t2.lastname as last_name,
    t2.email,
    t2.mobilephone as mobile_phone,
    '' as home_phone,
    t2.phone as work_phone,
    t2.address as street,
    lower(t2.city) as city,
    t2.state,
    t2.zip,
    left(t2.zip, 5) as trim_zip,
    t2.country,
    t2.company as company_name,
    '' as employee_count,
    t2.industry,
    t2.website as domain,
    '' as customer_crm,
    0 as company_revenue,
    '' as purchasing_dept,
    t1.updatedat as updated_date,
    case
        when t2.hs_lead_status IS NULL then '0'
        else '1'
    end as ld_updated_field
from
    `leads_db.hubspot_contacts` t1
    join `leads_db.hubspot_contacts_properties` t2 on t1.contact_id = t2.hs_object_id;
