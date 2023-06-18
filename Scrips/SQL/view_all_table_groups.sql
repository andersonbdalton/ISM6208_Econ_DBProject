--CPI Data
SELECT *
FROM
cpi_all_items_urban;

SELECT *
FROM
cpi_all_items_urban_pctchg;

SELECT *
FROM
cpi_median;

SELECT *
FROM
cpi_all;

--look at table by quarter
SELECT *
FROM
cpi_median_bq;


--M2 Data

SELECT *
FROM
m2_us;

SELECT *
FROM
m2_real_us;


--PCE Data

SELECT *
FROM
pce;

--GDP Data

SELECT *
FROM
us_hh_debt_gdp;

SELECT *
FROM
real_gdp_per_capita;

SELECT *
FROM
real_gdp;

--FED Rate data

SELECT *
FROM
real_interest_rate_10yr;

--RENAME mort_avg_30yr_fixed_rate_us TO mtg_avg_30yr_fixed_rate_us;

SELECT *
FROM
mtg_avg_30yr_fixed_rate_us;

SELECT *
FROM
fed_debt_total_public_debt;

SELECT *
FROM
fed_funds_effective_rate;

--RENAME interest_rate_reserve_balances TO int_rate_reserve_bal;
SELECT *
FROM
int_rate_reserve_bal;

SELECT *
FROM
treasury_yield_10yr;

--FED Debt data

SELECT *
FROM
fed_debt_frb;

SELECT *
FROM
fed_debt_gdp_pct;

SELECT *
FROM
fed_total_debt;

SELECT *
FROM
fed_total_public_debt;

SELECT *
FROM
gross_debt_pct_gdp;

SELECT *
FROM
debt_service_pct_income;

SELECT *
FROM
mtg_debt_service_pct_income;


--Unemployment Rate data

SELECT *
FROM
unemp_rate;

--RENAME mort_avg_30yr_fixed_rate_us TO mtg_avg_30yr_fixed_rate_us;

SELECT *
FROM
unemp_level;

SELECT *
FROM
noncyclical_unemp_rate;

SELECT *
FROM
sma_4wk_unemp_claims;

--Median Sales Price of Houses Sold for the United States (MSPUS) data
SELECT *
FROM
mspus;


--Mortgage Delinquency Rates data

--30 to 89
SELECT *
FROM
mtg_delinq_rates_co_30_89;

SELECT *
FROM
mort_delinq_rates_metro_30_89;

SELECT *
FROM
mort_delinq_rates_st_30_89;

-- 90 to 180
SELECT *
FROM
mort_delinq_rates_co_90plus;

SELECT *
FROM
mort_delinq_rates_metro_90plus;

SELECT *
FROM
mort_delinq_rates_co_90plus;


--COMMIT;