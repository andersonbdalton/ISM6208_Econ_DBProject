------------------------------------------------------------
------------------------------------------------------------
-- Title:    Final Project - Economic Data Analysis
-- Course:   ISM6208.020U23
-- Date:     June 2023
-- Authors:  Dalton Anderson & Kevin Hitt 
------------------------------------------------------------
------------------------------------------------------------

-- ########################################
-- ##### ADDING INDEXES
-- ########################################


-- New column of incremental identifiers / surrogate keys
-- added to be assigned as indexes
-- [BELOW REPEATED FOR ALL 9 TABLES]

ALTER TABLE CPI_MERGED ADD SURROGATE_KEY INT;
UPDATE CPI_MERGED SET SURROGATE_KEY = ROWNUM;

-- Now add as primary key
ALTER TABLE CPI_MERGED ADD CONSTRAINT cpi_merged_pk PRIMARY KEY (SURROGATE_KEY);
ALTER TABLE FED_DEBT_MERGED ADD CONSTRAINT FED_DEBT_MERGED_pk PRIMARY KEY (SURROGATE_KEY);
ALTER TABLE FED_RATE_MERGED ADD CONSTRAINT FED_RATE_MERGED_pk PRIMARY KEY (SURROGATE_KEY);
ALTER TABLE GDP_MERGED ADD CONSTRAINT GDP_MERGED_pk PRIMARY KEY (SURROGATE_KEY);
ALTER TABLE M2_MERGED ADD CONSTRAINT M2_MERGED_pk PRIMARY KEY (SURROGATE_KEY);
ALTER TABLE MORT_MERGED ADD CONSTRAINT MORT_MERGED_pk PRIMARY KEY (SURROGATE_KEY);
ALTER TABLE MSPUS ADD CONSTRAINT MSPUS_pk PRIMARY KEY (SURROGATE_KEY);
ALTER TABLE PCE ADD CONSTRAINT PCE_pk PRIMARY KEY (SURROGATE_KEY);
ALTER TABLE UNEMP_MERGED ADD CONSTRAINT UNEMP_MERGED_pk PRIMARY KEY (SURROGATE_KEY);

-- ########################################
-- ##### CREATING FACT TABLE
-- ########################################

CREATE TABLE FACT_DATA (
    SURROGATE_KEY INT PRIMARY KEY,
    RECORD_DATE DATE,
    -- Additional columns related to the fact data
    Dim_CPI_Key INT,
    Dim_FED_DEBT_Key INT,
    Dim_FED_RATE_Key INT,
    Dim_GDP_Key INT,
    Dim_M2_Key INT,
    Dim_MORT_Key INT,
    Dim_MSPUS_Key INT,
    Dim_PCE_Key INT,
    Dim_UNEMP_Key INT,
    FOREIGN KEY (Dim_CPI_Key) REFERENCES CPI_MERGED(Surrogate_Key),
    FOREIGN KEY (Dim_FED_DEBT_Key) REFERENCES FED_DEBT_MERGED(Surrogate_Key),
    FOREIGN KEY (Dim_FED_RATE_Key) REFERENCES FED_RATE_MERGED(Surrogate_Key),
    FOREIGN KEY (Dim_GDP_Key) REFERENCES GDP_MERGED(Surrogate_Key),
    FOREIGN KEY (Dim_M2_Key) REFERENCES M2_MERGED(Surrogate_Key),
    FOREIGN KEY (Dim_MORT_Key) REFERENCES MORT_MERGED(Surrogate_Key),
    FOREIGN KEY (Dim_MSPUS_Key) REFERENCES MSPUS(Surrogate_Key),
    FOREIGN KEY (Dim_PCE_Key) REFERENCES PCE(Surrogate_Key),
    FOREIGN KEY (Dim_UNEMP_Key) REFERENCES UNEMP_MERGED(Surrogate_Key)
);

SELECT * FROM FACT_DATA;


-- ########################################
-- ##### CREATING DATE DIMENSION TABLE
-- ########################################

-- Create DATE_DIM table
CREATE TABLE DATE_DIM
(
  JULIAN_DAY_KEY NUMBER(10) PRIMARY KEY,
  CAL_DATE DATE,
  CAL_TEXT VARCHAR2(10),
  DAY_NAME VARCHAR2(9),
  DAY_ABBREV VARCHAR2(3),
  DAY_IN_YEAR NUMBER(3),
  DAY_IN_MONTH NUMBER(2),
  DAY_IN_WEEK NUMBER(1),
  MONTH_NAME VARCHAR2(9),
  MONTH_ABBREV VARCHAR2(3),
  MONTH_NBR NUMBER(2),
  YEAR_NBR NUMBER(4),
  QUARTER_NBR NUMBER(1),
  CAL_QUARTER_KEY VARCHAR2(6)
);

DECLARE
  v_date DATE := TO_DATE('1940-01-01', 'YYYY-MM-DD');
BEGIN
  WHILE v_date <= TO_DATE('2023-12-31', 'YYYY-MM-DD') LOOP
    INSERT INTO DATE_DIM 
    VALUES (
      TO_CHAR(v_date, 'J'),
      v_date,
      TO_CHAR(v_date, 'MM/DD/YYYY'),
      TO_CHAR(v_date, 'DAY'),
      TO_CHAR(v_date, 'DY'),
      TO_CHAR(v_date, 'DDD'),
      TO_CHAR(v_date, 'DD'),
      TO_CHAR(v_date, 'D'),
      TO_CHAR(v_date, 'MONTH'),
      TO_CHAR(v_date, 'MON'),
      TO_CHAR(v_date, 'MM'),
      TO_CHAR(v_date, 'YYYY'),
      TO_CHAR(v_date, 'Q'),
      TO_CHAR(v_date, 'YYYY') || TO_CHAR(v_date, 'Q')
    );

    v_date := v_date + 1;
  END LOOP;
  COMMIT;
END;
/

SELECT * from DATE_DIM;

-- For all tables: 
-- Adding DATE_KEY column
-- Updating DATE_KEY column
-- Adding foreign key constraint


ALTER TABLE FACT_DATA ADD (DATE_KEY NUMBER(10));
ALTER TABLE FACT_DATA ADD CONSTRAINT fk_date_dim0 FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIM(JULIAN_DAY_KEY);

ALTER TABLE CPI_MERGED ADD (DATE_KEY NUMBER(10));
UPDATE CPI_MERGED cpi SET DATE_KEY = (SELECT dd.JULIAN_DAY_KEY FROM DATE_DIM dd WHERE dd.CAL_TEXT = TO_CHAR(cpi.RECORD_DATE, 'MM/DD/YYYY'));
ALTER TABLE CPI_MERGED ADD CONSTRAINT fk_date_dim FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIM(JULIAN_DAY_KEY);

ALTER TABLE FED_DEBT_MERGED ADD (DATE_KEY NUMBER(10));
UPDATE FED_DEBT_MERGED fdm SET DATE_KEY = (SELECT dd.JULIAN_DAY_KEY FROM DATE_DIM dd WHERE dd.CAL_TEXT = TO_CHAR(fdm.RECORD_DATE, 'MM/DD/YYYY'));
ALTER TABLE FED_DEBT_MERGED ADD CONSTRAINT fk_date_dim2 FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIM(JULIAN_DAY_KEY);

ALTER TABLE FED_RATE_MERGED ADD (DATE_KEY NUMBER(10));
UPDATE FED_RATE_MERGED frm SET DATE_KEY = (SELECT dd.JULIAN_DAY_KEY FROM DATE_DIM dd WHERE dd.CAL_TEXT = TO_CHAR(frm.RECORD_DATE, 'MM/DD/YYYY'));
ALTER TABLE FED_RATE_MERGED ADD CONSTRAINT fk_date_dim3 FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIM(JULIAN_DAY_KEY);

ALTER TABLE GDP_MERGED ADD (DATE_KEY NUMBER(10));
UPDATE GDP_MERGED gdp SET DATE_KEY = (SELECT dd.JULIAN_DAY_KEY FROM DATE_DIM dd WHERE dd.CAL_TEXT = TO_CHAR(gdp.RECORD_DATE, 'MM/DD/YYYY'));
ALTER TABLE GDP_MERGED ADD CONSTRAINT fk_date_dim4 FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIM(JULIAN_DAY_KEY);

ALTER TABLE M2_MERGED ADD (DATE_KEY NUMBER(10));
UPDATE M2_MERGED m2 SET DATE_KEY = (SELECT dd.JULIAN_DAY_KEY FROM DATE_DIM dd WHERE dd.CAL_TEXT = TO_CHAR(m2.RECORD_DATE, 'MM/DD/YYYY'));
ALTER TABLE M2_MERGED ADD CONSTRAINT fk_date_dim5 FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIM(JULIAN_DAY_KEY);

ALTER TABLE MORT_MERGED ADD (DATE_KEY NUMBER(10));
UPDATE MORT_MERGED mm SET DATE_KEY = (SELECT dd.JULIAN_DAY_KEY FROM DATE_DIM dd WHERE dd.CAL_TEXT = TO_CHAR(mm.RECORD_DATE, 'MM/DD/YYYY'));
ALTER TABLE MORT_MERGED ADD CONSTRAINT fk_date_dim6 FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIM(JULIAN_DAY_KEY);

ALTER TABLE MSPUS ADD (DATE_KEY NUMBER(10));
UPDATE MSPUS mspus SET DATE_KEY = (SELECT dd.JULIAN_DAY_KEY FROM DATE_DIM dd WHERE dd.CAL_TEXT = TO_CHAR(mspus.RECORD_DATE, 'MM/DD/YYYY'));
ALTER TABLE MSPUS ADD CONSTRAINT fk_date_dim7 FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIM(JULIAN_DAY_KEY);

ALTER TABLE PCE ADD (DATE_KEY NUMBER(10));
UPDATE PCE pce SET DATE_KEY = (SELECT dd.JULIAN_DAY_KEY FROM DATE_DIM dd WHERE dd.CAL_TEXT = TO_CHAR(pce.RECORD_DATE, 'MM/DD/YYYY'));
ALTER TABLE PCE ADD CONSTRAINT fk_date_dim8 FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIM(JULIAN_DAY_KEY);

ALTER TABLE UNEMP_MERGED ADD (DATE_KEY NUMBER(10));
UPDATE UNEMP_MERGED unemp SET DATE_KEY = (SELECT dd.JULIAN_DAY_KEY FROM DATE_DIM dd WHERE dd.CAL_TEXT = TO_CHAR(unemp.RECORD_DATE, 'MM/DD/YYYY'));
ALTER TABLE UNEMP_MERGED ADD CONSTRAINT fk_date_dim9 FOREIGN KEY (DATE_KEY) REFERENCES DATE_DIM(JULIAN_DAY_KEY);