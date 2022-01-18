select
    t1.account_name,
    t1.billing_number,
    t1.final_amount,
    t2.total_applied,
    date(t1.opp_created_date) as opp_date,
    t1.industry,
    t1.state,
    t1.payment_plan,
    case
        when t1.payment_plan ='Custom' then 'Custom/Check/Inv.'
        when t1.payment_plan ='Invoice' then 'Custom/Check/Inv.'
        when t1.payment_plan ='Check' then 'Custom/Check/Inv.'
        when t1.payment_plan ='Once Paid in Full (Due Upon Signing)' then 'PIF'
        when t1.payment_plan ='12 Monthly Equal Payments (1st Due Upon Signing)' then '12 Mths.'
        when t1.payment_plan ='6 Monthly Equal Payments (1st Due Upon Signing)' then '6 Mths.'
        when t1.payment_plan ='3 Monthly Equal Payments (1st Due Upon Signing)' then '3 Mths.'
        when t1.payment_plan ='50% Due Upon Signing (Next Payment Due in 30 Days)' then '2 Mths.'
        else 'Other'
    end as adj_payment_plan,
    case
        when t3.sector IS NULL then 'Missing'
        else t3.sector
    end as adj_sector,
    t4.product_type,
    t4.prod_grp_type,
    t5.billings
from
    mbg.customer_value t1
    left join (
        select
            billing_number,
            sum(applied_amount) as total_applied
        from
            mbg.cust_value_rcpts
        group by
            billing_number
    ) t2 on t1.billing_number = t2.billing_number
    left join mbg.sector_mapping t3 on t1.industry = t3.industry
    left join (
        select
            billing_number,
            product_type,case
                when product_type like '%2 Star%' then '2 star'
                when product_type like '%3 Star%' then '3 star'
                when product_type like '%4 Star%' then '4 star'
                else 'Other'
            end as prod_grp_type
        from
            mbg.cust_products
    ) t4 on t1.billing_number = t4.billing_number
    left join (
        select
            account_name,
            count(billing_number) as billings
        from
            mbg.billing_cnt
        group by
            account_name
    ) t5 on t1.account_name = t5.account_name;
