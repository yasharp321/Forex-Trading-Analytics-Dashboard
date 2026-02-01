CREATE DATABASE forex_analytics;

CREATE TABLE eurusd_prices (
    price_date DATE,
    open_price DECIMAL(10,5),
    high_price DECIMAL(10,5),
    low_price  DECIMAL(10,5),
    close_price DECIMAL(10,5),
    volume BIGINT
);
DROP TABLE IF EXISTS eurusd_prices;

CREATE TABLE eurusd_prices_1h (
    price_time DATETIME,
    open_price DECIMAL(10,5),
    high_price DECIMAL(10,5),
    low_price  DECIMAL(10,5),
    close_price DECIMAL(10,5),
    tick_volume INT,
    spread INT
);

SELECT COUNT(*) FROM eurusd_prices_1h;

-- 1> date range
SELECT 
    MIN(price_time) AS start_date,
    MAX(price_time) AS end_date
FROM eurusd_prices_1h;

-- 2> Price movement per candle 
SELECT
    price_time,
    close_price - open_price AS price_change
FROM eurusd_prices_1h
LIMIT 10;

-- 3>Return % 
SELECT
    price_time,
    (close_price - open_price) / open_price * 100 AS return_pct
FROM eurusd_prices_1h
LIMIT 10;

-- Direction (BUY/SELL) 
SELECT
    price_time,
    open_price,
    close_price,
    CASE
        WHEN close_price > open_price THEN 'BUY'
        ELSE 'SELL'
    END AS trade_direction
FROM eurusd_prices_1h
LIMIT 10;

-- 4> P&L Calculation
SELECT
    price_time,
    CASE
        WHEN close_price > open_price
        THEN (close_price - open_price) * 100000
        ELSE (open_price - close_price) * 100000
    END AS pnl_usd
FROM eurusd_prices_1h
LIMIT 10;

-- Volatility 
SELECT
    price_time,
    high_price - low_price AS volatility
FROM eurusd_prices_1h
LIMIT 10;

-- Cumulative P&L
 SELECT
    price_time,
    SUM(
        CASE
            WHEN close_price > open_price
            THEN (close_price - open_price) * 100000
            ELSE (open_price - close_price) * 100000
        END
    ) OVER (ORDER BY price_time) AS cumulative_pnl
FROM eurusd_prices_1h;

-- ANALYTICS VIEW
 
CREATE VIEW forex_analytics_1h AS
SELECT
    price_time,
    open_price,
    high_price,
    low_price,
    close_price,
    (close_price - open_price) AS price_change,
    (close_price - open_price) / open_price * 100 AS return_pct,
    high_price - low_price AS volatility,
    CASE
        WHEN close_price > open_price THEN 'BUY'
        ELSE 'SELL'
    END AS direction,
    CASE
        WHEN close_price > open_price
        THEN (close_price - open_price) * 100000
        ELSE (open_price - close_price) * 100000
    END AS pnl_usd
FROM eurusd_prices_1h;




