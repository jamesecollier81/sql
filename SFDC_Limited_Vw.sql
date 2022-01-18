SELECT
    id,
    FirstName as first_name,
    LastName as last_name,
    Email as email,
    Phone as mobile_phone,
    Street as street,
    --street2,
    City as city,
    State as state,
    PostalCode as zip,
    Country as country,
    Owner_Full_Name__c as owner_name,
    Lead_Owner_Role__c as title,
    Company as company_name,
    NumberOfEmployees as employee_count,
    Industry as industry,
    LinkedIn__c as linkedin,
    Website as domain,
    JumpCrew_Sale_Type__c as lead_type
FROM
    leads_db.sfdc_leads
WHERE
    (
        Industry <> ""
        and Company <> ""
        and FirstName <> ""
        and State <> ""
    );
