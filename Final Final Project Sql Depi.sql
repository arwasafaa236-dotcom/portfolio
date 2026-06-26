-- ============================================================
-- AIRLINE ROUTE PROFITABILITY - COMPLETE PROJECT SCRIPT
-- Emirates Airlines (EK) - Dubai Hub (DXB) - Year 2024
-- ============================================================


-- ============================================================
-- PART 1: DATABASE & TABLES CREATION
-- ============================================================

DROP DATABASE IF EXISTS airline_analysis;
CREATE DATABASE airline_analysis;
USE airline_analysis;

-- جدول الطائرات
CREATE TABLE aircraft (
    aircraft_id   INT AUTO_INCREMENT PRIMARY KEY,
    aircraft_type VARCHAR(50)  NOT NULL,
    capacity      INT          NOT NULL
);

-- جدول المسارات
CREATE TABLE routes (
    route_id       INT AUTO_INCREMENT PRIMARY KEY,
    origin         VARCHAR(10)  NOT NULL,
    destination    VARCHAR(10)  NOT NULL,
    route_code     VARCHAR(20)  NOT NULL UNIQUE,
    route_category VARCHAR(20)  NOT NULL,
    flight_hours   DECIMAL(4,1) NOT NULL
);

-- جدول الرحلات
CREATE TABLE flights (
    flight_id     INT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(10)  NOT NULL,
    flight_date   DATE         NOT NULL,
    passengers    INT          NOT NULL,
    load_factor   DECIMAL(5,4) NOT NULL,
    season        VARCHAR(20)  NOT NULL,
    demand_level  VARCHAR(20)  NOT NULL,
    aircraft_id   INT          NOT NULL,
    route_id      INT          NOT NULL,
    FOREIGN KEY (aircraft_id) REFERENCES aircraft(aircraft_id),
    FOREIGN KEY (route_id)    REFERENCES routes(route_id)
);

-- جدول البيانات المالية
CREATE TABLE financials (
    fin_id                  INT AUTO_INCREMENT PRIMARY KEY,
    flight_id               INT           NOT NULL UNIQUE,
    ticket_revenue          DECIMAL(12,2) NOT NULL,
    ancillary_revenue       DECIMAL(12,2),
    total_revenue           DECIMAL(12,2) NOT NULL,
    fuel_cost               DECIMAL(12,2) NOT NULL,
    maintenance_cost        DECIMAL(12,2) NOT NULL,
    crew_cost               DECIMAL(12,2) NOT NULL,
    depreciation_cost       DECIMAL(12,2) NOT NULL,
    insurance_cost          DECIMAL(12,2) NOT NULL,
    airport_fees            DECIMAL(12,2) NOT NULL,
    catering_cost           DECIMAL(12,2),
    handling_cost           DECIMAL(12,2),
    navigation_fees         DECIMAL(12,2) NOT NULL,
    sales_distribution_cost DECIMAL(12,2) NOT NULL,
    passenger_service_cost  DECIMAL(12,2) NOT NULL,
    overhead_cost           DECIMAL(12,2) NOT NULL,
    marketing_cost          DECIMAL(12,2) NOT NULL,
    it_systems_cost         DECIMAL(12,2) NOT NULL,
    total_cost              DECIMAL(12,2) NOT NULL,
    profit                  DECIMAL(12,2) NOT NULL,
    profit_margin           DECIMAL(7,2)  NOT NULL,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- جداول مؤقتة للاستيراد
CREATE TABLE flights_staging (
    flight_number  VARCHAR(10),
    flight_date    VARCHAR(20),
    origin         VARCHAR(10),
    destination    VARCHAR(10),
    route          VARCHAR(20),
    aircraft_type  VARCHAR(50),
    capacity       INT,
    passengers     INT,
    load_factor    DECIMAL(5,4),
    flight_hours   DECIMAL(4,1),
    season         VARCHAR(20),
    route_category VARCHAR(20),
    demand_level   VARCHAR(20)
);

CREATE TABLE financials_staging (
    flight_number           VARCHAR(10),
    flight_date             VARCHAR(20),
    ticket_revenue          DECIMAL(12,2),
    ancillary_revenue       DECIMAL(12,2),
    total_revenue           DECIMAL(12,2),
    fuel_cost               DECIMAL(12,2),
    maintenance_cost        DECIMAL(12,2),
    crew_cost               DECIMAL(12,2),
    depreciation_cost       DECIMAL(12,2),
    insurance_cost          DECIMAL(12,2),
    airport_fees            DECIMAL(12,2),
    catering_cost           DECIMAL(12,2),
    handling_cost           DECIMAL(12,2),
    navigation_fees         DECIMAL(12,2),
    sales_distribution_cost DECIMAL(12,2),
    passenger_service_cost  DECIMAL(12,2),
    overhead_cost           DECIMAL(12,2),
    marketing_cost          DECIMAL(12,2),
    it_systems_cost         DECIMAL(12,2),
    total_cost              DECIMAL(12,2),
    profit                  DECIMAL(12,2),
    profit_margin           DECIMAL(7,2)
);

-- Indexes لتسريع الاستعلامات
CREATE INDEX idx_flight_date   ON flights(flight_date);
CREATE INDEX idx_season        ON flights(season);
CREATE INDEX idx_profit_margin ON financials(profit_margin);


-- ============================================================
-- PART 2: INSERT REFERENCE DATA
-- ============================================================

-- إدخال بيانات الطائرات
INSERT INTO aircraft (aircraft_type, capacity) VALUES
('Airbus A320',       180),
('Boeing 737-800',    189),
('Airbus A350-900',   325),
('Boeing 787-9',      296),
('Boeing 777-300ER',  396),
('Airbus A380',       517);

-- إدخال بيانات المسارات
INSERT INTO routes (origin, destination, route_code, route_category, flight_hours) VALUES
('DXB', 'AMM', 'DXB-AMM', 'Short Haul',  3.2),
('DXB', 'BAH', 'DXB-BAH', 'Short Haul',  1.3),
('DXB', 'BKK', 'DXB-BKK', 'Long Haul',   6.5),
('DXB', 'BLR', 'DXB-BLR', 'Medium Haul', 4.5),
('DXB', 'BOM', 'DXB-BOM', 'Medium Haul', 3.2),
('DXB', 'CAI', 'DXB-CAI', 'Short Haul',  3.5),
('DXB', 'CDG', 'DXB-CDG', 'Long Haul',   7.5),
('DXB', 'CMB', 'DXB-CMB', 'Medium Haul', 4.5),
('DXB', 'DEL', 'DXB-DEL', 'Medium Haul', 3.5),
('DXB', 'DOH', 'DXB-DOH', 'Short Haul',  1.5),
('DXB', 'FRA', 'DXB-FRA', 'Long Haul',   6.5),
('DXB', 'HKG', 'DXB-HKG', 'Long Haul',   8.5),
('DXB', 'HYD', 'DXB-HYD', 'Medium Haul', 4.2),
('DXB', 'IST', 'DXB-IST', 'Medium Haul', 5.0),
('DXB', 'JED', 'DXB-JED', 'Short Haul',  3.0),
('DXB', 'JFK', 'DXB-JFK', 'Long Haul',  14.0),
('DXB', 'KHI', 'DXB-KHI', 'Medium Haul', 2.5),
('DXB', 'KUL', 'DXB-KUL', 'Long Haul',   7.5),
('DXB', 'KWI', 'DXB-KWI', 'Short Haul',  2.0),
('DXB', 'LAX', 'DXB-LAX', 'Long Haul',  16.0),
('DXB', 'LHE', 'DXB-LHE', 'Medium Haul', 3.5),
('DXB', 'LHR', 'DXB-LHR', 'Medium Haul', 7.0),
('DXB', 'MAA', 'DXB-MAA', 'Medium Haul', 4.5),
('DXB', 'MCT', 'DXB-MCT', 'Short Haul',  1.2),
('DXB', 'MEL', 'DXB-MEL', 'Long Haul',  13.5),
('DXB', 'ORD', 'DXB-ORD', 'Long Haul',  14.5),
('DXB', 'RUH', 'DXB-RUH', 'Short Haul',  2.2),
('DXB', 'SFO', 'DXB-SFO', 'Long Haul',  16.5),
('DXB', 'SIN', 'DXB-SIN', 'Long Haul',   7.5),
('DXB', 'SYD', 'DXB-SYD', 'Long Haul',  14.5);


-- ============================================================
-- PART 3: TRANSFER DATA FROM STAGING TO PRODUCTION TABLES
-- (يتشغل بعد ما تستورد البيانات من الاكسيل في الجداول المؤقتة)
-- ============================================================

-- نقل بيانات الرحلات
INSERT INTO flights (flight_number, flight_date, passengers, load_factor, season, demand_level, aircraft_id, route_id)
SELECT
    s.flight_number,
    STR_TO_DATE(s.flight_date, '%Y-%m-%d'),
    s.passengers,
    s.load_factor,
    s.season,
    s.demand_level,
    a.aircraft_id,
    r.route_id
FROM flights_staging s
JOIN aircraft a ON s.aircraft_type = a.aircraft_type
JOIN routes   r ON s.route         = r.route_code;

-- نقل البيانات المالية
INSERT INTO financials (
    flight_id, ticket_revenue, ancillary_revenue, total_revenue,
    fuel_cost, maintenance_cost, crew_cost, depreciation_cost,
    insurance_cost, airport_fees, catering_cost, handling_cost,
    navigation_fees, sales_distribution_cost, passenger_service_cost,
    overhead_cost, marketing_cost, it_systems_cost,
    total_cost, profit, profit_margin
)
SELECT
    f.flight_id,
    fs.ticket_revenue, fs.ancillary_revenue, fs.total_revenue,
    fs.fuel_cost, fs.maintenance_cost, fs.crew_cost, fs.depreciation_cost,
    fs.insurance_cost, fs.airport_fees, fs.catering_cost, fs.handling_cost,
    fs.navigation_fees, fs.sales_distribution_cost, fs.passenger_service_cost,
    fs.overhead_cost, fs.marketing_cost, fs.it_systems_cost,
    fs.total_cost, fs.profit, fs.profit_margin
FROM financials_staging fs
JOIN flights f ON fs.flight_number = f.flight_number
              AND fs.flight_date = DATE_FORMAT(f.flight_date, '%Y-%m-%d');

-- التحقق من البيانات
SELECT COUNT(*) AS flights_count    FROM flights;
SELECT COUNT(*) AS financials_count FROM financials;


-- ============================================================
-- PART 4: ANALYSIS QUERIES
-- ============================================================

-- التحليل الأول: الصورة العامة للأرباح
SELECT
    COUNT(*)                             AS عدد_الرحلات,
    ROUND(AVG(profit), 2)               AS متوسط_الربح,
    ROUND(AVG(profit_margin), 2)        AS متوسط_نسبة_الربح,
    ROUND(MAX(profit_margin), 2)        AS أعلى_نسبة_ربح,
    ROUND(MIN(profit_margin), 2)        AS أدنى_نسبة_ربح,
    SUM(CASE WHEN profit < 0 THEN 1 ELSE 0 END) AS رحلات_خسرانة
FROM financials;

-- التحليل الثاني: ربحية كل وجهة
SELECT
    r.destination                        AS الوجهة,
    r.route_category                     AS نوع_الرحلة,
    COUNT(*)                             AS عدد_الرحلات,
    ROUND(AVG(f.profit_margin), 2)       AS متوسط_نسبة_الربح,
    ROUND(AVG(f.profit), 2)             AS متوسط_الربح,
    ROUND(SUM(f.profit), 2)             AS إجمالي_الربح,
    SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS رحلات_خسرانة
FROM financials f
JOIN flights fl ON f.flight_id  = fl.flight_id
JOIN routes  r  ON fl.route_id  = r.route_id
GROUP BY r.destination, r.route_category
ORDER BY متوسط_نسبة_الربح DESC;

-- التحليل الثالث: تأثير الموسم على الأرباح
SELECT
    fl.season                            AS الموسم,
    COUNT(*)                             AS عدد_الرحلات,
    ROUND(AVG(f.profit_margin), 2)       AS متوسط_نسبة_الربح,
    ROUND(AVG(fl.load_factor) * 100, 2) AS متوسط_نسبة_الامتلاء,
    ROUND(SUM(f.profit), 2)             AS إجمالي_الربح,
    SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS رحلات_خسرانة
FROM financials f
JOIN flights fl ON f.flight_id = fl.flight_id
GROUP BY fl.season
ORDER BY متوسط_نسبة_الربح DESC;

-- التحليل الرابع: كفاءة كل نوع طيارة
SELECT
    a.aircraft_type                      AS نوع_الطيارة,
    a.capacity                           AS السعة,
    COUNT(*)                             AS عدد_الرحلات,
    ROUND(AVG(f.profit_margin), 2)       AS متوسط_نسبة_الربح,
    ROUND(AVG(fl.load_factor) * 100, 2) AS متوسط_نسبة_الامتلاء,
    ROUND(AVG(f.fuel_cost), 2)          AS متوسط_تكلفة_الوقود,
    ROUND(SUM(f.profit), 2)             AS إجمالي_الربح,
    SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS رحلات_خسرانة
FROM financials f
JOIN flights  fl ON f.flight_id   = fl.flight_id
JOIN aircraft a  ON fl.aircraft_id = a.aircraft_id
GROUP BY a.aircraft_type, a.capacity
ORDER BY متوسط_نسبة_الربح DESC;

-- التحليل الخامس: علاقة نسبة الامتلاء بالربح
SELECT
    CASE
        WHEN fl.load_factor < 0.60 THEN 'أقل من 60%'
        WHEN fl.load_factor < 0.70 THEN '60% - 70%'
        WHEN fl.load_factor < 0.80 THEN '70% - 80%'
        WHEN fl.load_factor < 0.90 THEN '80% - 90%'
        ELSE 'أكتر من 90%'
    END                                  AS نسبة_الامتلاء,
    COUNT(*)                             AS عدد_الرحلات,
    ROUND(AVG(f.profit_margin), 2)       AS متوسط_نسبة_الربح,
    ROUND(AVG(f.total_revenue), 2)       AS متوسط_الإيراد,
    ROUND(AVG(f.total_cost), 2)         AS متوسط_التكلفة,
    SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS رحلات_خسرانة
FROM financials f
JOIN flights fl ON f.flight_id = fl.flight_id
GROUP BY نسبة_الامتلاء
ORDER BY متوسط_نسبة_الربح DESC;

-- التحليل السادس: هيكل التكاليف
SELECT 'وقود'           AS نوع_التكلفة, ROUND(AVG(fuel_cost), 2) AS متوسط_التكلفة, ROUND(AVG(fuel_cost)/AVG(total_cost)*100, 2) AS نسبة_من_الإجمالي FROM financials
UNION ALL
SELECT 'مبيعات وتوزيع', ROUND(AVG(sales_distribution_cost), 2), ROUND(AVG(sales_distribution_cost)/AVG(total_cost)*100, 2) FROM financials
UNION ALL
SELECT 'overhead',       ROUND(AVG(overhead_cost), 2), ROUND(AVG(overhead_cost)/AVG(total_cost)*100, 2) FROM financials
UNION ALL
SELECT 'استهلاك',       ROUND(AVG(depreciation_cost), 2), ROUND(AVG(depreciation_cost)/AVG(total_cost)*100, 2) FROM financials
UNION ALL
SELECT 'صيانة',         ROUND(AVG(maintenance_cost), 2), ROUND(AVG(maintenance_cost)/AVG(total_cost)*100, 2) FROM financials
UNION ALL
SELECT 'طاقم',          ROUND(AVG(crew_cost), 2), ROUND(AVG(crew_cost)/AVG(total_cost)*100, 2) FROM financials
ORDER BY متوسط_التكلفة DESC;


-- ============================================================
-- PART 5: VIEWS
-- ============================================================

DROP VIEW IF EXISTS v_route_profitability;
CREATE VIEW v_route_profitability AS
SELECT
    r.destination                        AS destination,
    r.route_category                     AS route_category,
    COUNT(*)                             AS total_flights,
    ROUND(AVG(f.profit_margin), 2)       AS avg_profit_margin,
    ROUND(AVG(f.profit), 2)             AS avg_profit,
    ROUND(SUM(f.profit), 2)             AS total_profit,
    SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS loss_flights
FROM financials f
JOIN flights fl ON f.flight_id = fl.flight_id
JOIN routes  r  ON fl.route_id = r.route_id
GROUP BY r.destination, r.route_category;

DROP VIEW IF EXISTS v_season_profitability;
CREATE VIEW v_season_profitability AS
SELECT
    fl.season                            AS season,
    COUNT(*)                             AS total_flights,
    ROUND(AVG(f.profit_margin), 2)       AS avg_profit_margin,
    ROUND(AVG(fl.load_factor) * 100, 2) AS avg_load_factor,
    ROUND(SUM(f.profit), 2)             AS total_profit,
    SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS loss_flights
FROM financials f
JOIN flights fl ON f.flight_id = fl.flight_id
GROUP BY fl.season;

DROP VIEW IF EXISTS v_aircraft_performance;
CREATE VIEW v_aircraft_performance AS
SELECT
    a.aircraft_type                      AS aircraft_type,
    a.capacity                           AS capacity,
    COUNT(*)                             AS total_flights,
    ROUND(AVG(f.profit_margin), 2)       AS avg_profit_margin,
    ROUND(AVG(fl.load_factor) * 100, 2) AS avg_load_factor,
    ROUND(AVG(f.fuel_cost), 2)          AS avg_fuel_cost,
    ROUND(SUM(f.profit), 2)             AS total_profit,
    SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS loss_flights
FROM financials f
JOIN flights  fl ON f.flight_id   = fl.flight_id
JOIN aircraft a  ON fl.aircraft_id = a.aircraft_id
GROUP BY a.aircraft_type, a.capacity;

DROP VIEW IF EXISTS v_load_factor_analysis;
CREATE VIEW v_load_factor_analysis AS
SELECT
    CASE
        WHEN fl.load_factor < 0.60 THEN 'Below 60%'
        WHEN fl.load_factor < 0.70 THEN '60% - 70%'
        WHEN fl.load_factor < 0.80 THEN '70% - 80%'
        WHEN fl.load_factor < 0.90 THEN '80% - 90%'
        ELSE 'Above 90%'
    END                                  AS load_factor_range,
    COUNT(*)                             AS total_flights,
    ROUND(AVG(f.profit_margin), 2)       AS avg_profit_margin,
    ROUND(AVG(f.total_revenue), 2)       AS avg_revenue,
    ROUND(AVG(f.total_cost), 2)         AS avg_cost,
    SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS loss_flights
FROM financials f
JOIN flights fl ON f.flight_id = fl.flight_id
GROUP BY load_factor_range;

-- استعراض الـ Views
SELECT * FROM v_route_profitability      ORDER BY avg_profit_margin DESC;
SELECT * FROM v_season_profitability     ORDER BY avg_profit_margin DESC;
SELECT * FROM v_aircraft_performance     ORDER BY avg_profit_margin DESC;
SELECT * FROM v_load_factor_analysis     ORDER BY avg_profit_margin DESC;


-- ============================================================
-- PART 6: STORED PROCEDURES
-- ============================================================

DROP PROCEDURE IF EXISTS sp_route_report;
DROP PROCEDURE IF EXISTS sp_top_routes_by_season;

DELIMITER $$

CREATE PROCEDURE sp_route_report(IN dest_code VARCHAR(10))
BEGIN
    SELECT
        r.destination,
        r.route_category,
        COUNT(*)                             AS total_flights,
        ROUND(AVG(f.profit_margin), 2)       AS avg_profit_margin,
        ROUND(AVG(fl.load_factor) * 100, 2) AS avg_load_factor,
        ROUND(SUM(f.profit), 2)             AS total_profit,
        SUM(CASE WHEN f.profit < 0 THEN 1 ELSE 0 END) AS loss_flights
    FROM financials f
    JOIN flights  fl ON f.flight_id  = fl.flight_id
    JOIN routes   r  ON fl.route_id  = r.route_id
    WHERE r.destination = dest_code
    GROUP BY r.destination, r.route_category;
END$$

CREATE PROCEDURE sp_top_routes_by_season(IN season_name VARCHAR(20))
BEGIN
    SELECT
        r.destination,
        r.route_category,
        COUNT(*)                             AS total_flights,
        ROUND(AVG(f.profit_margin), 2)       AS avg_profit_margin,
        ROUND(SUM(f.profit), 2)             AS total_profit
    FROM financials f
    JOIN flights fl ON f.flight_id = fl.flight_id
    JOIN routes  r  ON fl.route_id = r.route_id
    WHERE fl.season = season_name
    GROUP BY r.destination, r.route_category
    ORDER BY avg_profit_margin DESC
    LIMIT 5;
END$$

DELIMITER ;

-- تجربة الـ Stored Procedures
CALL sp_route_report('FRA');
CALL sp_top_routes_by_season('Peak');

-- ============================================================
-- END OF PROJECT SCRIPT
-- ============================================================
