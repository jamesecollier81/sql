select 
    *,
    case 
        when source_system='SalesForce' then 2
        when source_system='Hubspot' then 1
        when source_system='Outreach' then 5
        else 0
    end as data_rank,
    case   
        when domain IS NULL then "N"
        else "Y"
    end as domain_yn,
    case   
        when email IS NULL then "N"
        else "Y"
    end as email_yn,
    case   
        when first_name IS NULL and last_name IS NULL then "N"
        else "Y"
    end as names_yn,
    case   
        when mobile_phone IS NULL then "N"
        else "Y"
    end as phone_yn,
    case   
        when company_name IS NULL then 0
        else 1
    end as accounts,
    case   
        when street IS NULL and city IS NULL and zip IS NULL then 0
        else 1
    end as addresses,
    case
        when mobile_phone IS NULL and email IS NULL and work_phone IS NULL and home_phone IS NULL then 0 
        else 1
    end as contacts,
    case
        when domain IS NULL then 0
        else 1
    end as domains,
    case 
        when industry IS NULL then 0
        else 1
    end as industries,
    case
        when state IS NULL then 0
        else 1
    end as states,
    /*I will change the logic of this to look at the stages to make sure a change was made*/
    case
        when ld_updated_field = '0' then "No"
        else "Yes"
    end as lead_edited,
    /*would also be nice to have some kind of field/logic from sfdc to mark as verified*/
    case
        when source_system='Outreach' then 'Y'
        when source_system='Hubspot' then 'Y'
        else 'N'
    end as verified_data
from   
   (select
        t1.id,
        'SalesForce' as source_system,
        'SFDC' as instance,
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
        0 as company_revenue,
        '' as purchasing_dept,
        t1.updated_date,
        case
            when t1.ld_updated_field IS NULL then '1'
            else '1'
        end as ld_updated_field
    from
        leads_db.sfdc_limited t1
        left join leads_db.leads_state_mapping t2 on lower(t1.state) = t2.state
    UNION
        DISTINCT
    select
        t3.id,
        t3.source_system,
        replace(
            replace(
                replace(
                    replace(
                        replace(
                            replace(
                                replace(
                                    replace(replace(replace(t3.id, '0', ''), '1', ''), '2', ''),
                                    '3',
                                    ''
                                ),
                                '4',
                                ''
                            ),
                            '5',
                            ''
                        ),
                        '6',
                        ''
                    ),
                    '7',
                    ''
                ),
                '8',
                ''
            ),
            '9',
            ''
        ) as instance,
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
        t3.updated_date,
        case
            when t3.stage IS NULL then '0'
            else '1'
        end as ld_updated_field
    from
        leads_db.vw_outreach t3
        left join leads_db.leads_state_mapping t2 on lower(t3.state) = t2.state
    UNION
        DISTINCT
    select 
        t4.id,
        t4.source_system,
        t4.instance,
        t4.first_name,
        t4.last_name,
        t4.email,
        t4.mobile_phone,
        t4.home_phone,
        t4.work_phone,
        t4.street,
        t4.city,
        t2.mapped_state as state,
        t4.zip,
        t4.trim_zip,
        t4.country,
        t4.company_name,
        0 as employee_count,
        t4.industry,
        t4.domain,
        t4.customer_crm,
        t4.company_revenue,
        t4.purchasing_dept,
        t4.updated_date,
        t4.ld_updated_field
    from 
        leads_db.vw_hubspot_trimmed t4
        left join leads_db.leads_state_mapping t2 on lower(t4.state) = t2.state);
