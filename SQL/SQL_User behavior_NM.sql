-- =========================
-- DATABASE
-- =========================

DROP DATABASE user_behavior;
CREATE DATABASE user_behavior;
USE user_behavior;

-- =========================
-- TABLE 1: USERS
-- =========================

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    age INT,
    gender VARCHAR(10),
    location VARCHAR(50)
);

INSERT INTO users VALUES
(1,40,'Male','Hyderabad'),
(2,47,'Female','Bangalore'),
(3,42,'Male','Delhi'),
(4,20,'Male','Mumbai'),
(5,31,'Female','Delhi'),
(6,31,'Male','Mumbai'),
(7,21,'Female','Mumbai'),
(8,31,'Male','Bangalore'),
(9,42,'Female','Hyderabad'),
(10,42,'Male','Chennai'),
(11,34,'Female','Hyderabad'),
(12,24,'Male','Hyderabad'),
(13,57,'Female','Delhi'),
(14,43,'Male','Chennai'),
(15,49,'Female','Delhi'),
(16,39,'Female','Mumbai'),
(17,47,'Female','Hyderabad'),
(18,44,'Female','Bangalore'),
(19,26,'Female','Delhi'),
(20,29,'Female','Hyderabad');

SELECT * FROM users;

-- =========================
-- TABLE 2: DEVICES
-- =========================

CREATE TABLE devices (
    device_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    device_model VARCHAR(50),
    operating_system VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO devices (user_id, device_model, operating_system) VALUES
(1,'Google Pixel 5','Android'),
(2,'OnePlus 9','Android'),
(3,'Xiaomi Mi 11','Android'),
(4,'Google Pixel 5','Android'),
(5,'iPhone 12','iOS'),
(6,'Google Pixel 5','Android'),
(7,'Samsung Galaxy S21','Android'),
(8,'OnePlus 9','Android'),
(9,'Samsung Galaxy S21','Android'),
(10,'iPhone 12','iOS'),
(11,'Google Pixel 5','Android'),
(12,'OnePlus 9','Android'),
(13,'OnePlus 9','Android'),
(14,'Xiaomi Mi 11','Android'),
(15,'iPhone 12','iOS'),
(16,'Google Pixel 5','Android'),
(17,'OnePlus 9','Android'),
(18,'iPhone 12','iOS'),
(19,'Google Pixel 5','Android'),
(20,'iPhone 12','iOS');

SELECT * FROM devices;

-- =========================
-- TABLE 3: USAGE DATA
-- =========================

CREATE TABLE usage_data (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    app_usage_time INT,
    screen_time DECIMAL(4,1),
    battery_drain INT,
    data_usage INT,
    session_count INT,
    engagement_level VARCHAR(10),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

INSERT INTO usage_data 
(user_id, app_usage_time, screen_time, battery_drain, data_usage, session_count, engagement_level)
VALUES
(1,393,6.4,1872,122,3,'High'),
(2,268,4.7,1331,944,10,'Medium'),
(3,154,4.0,761,322,9,'Medium'),
(4,239,4.8,1676,871,10,'Medium'),
(5,187,4.3,1367,988,2,'Medium'),
(6,99,2.0,940,684,7,'Low'),
(7,350,7.3,1802,1054,1,'High'),
(8,543,11.4,2956,1702,4,'High'),
(9,340,7.7,2138,1053,10,'High'),
(10,424,6.6,1957,1301,6,'High'),
(11,53,1.4,435,162,7,'Low'),
(12,215,5.5,1690,641,3,'Medium'),
(13,462,6.2,2303,1099,7,'High'),
(14,215,4.9,1662,857,10,'Medium'),
(15,189,5.4,1754,779,2,'Medium'),
(16,503,10.4,2571,2025,8,'High'),
(17,132,3.6,628,344,10,'Low'),
(18,299,5.8,1431,385,2,'Medium'),
(19,81,1.4,558,297,2,'Low'),
(20,577,8.5,2774,2192,7,'High');

SELECT * FROM usage_data;

-- =========================
-- QUERIES
-- =========================

-- Total usage per user
SELECT u.user_id,
SUM(ud.app_usage_time) AS total_usage
FROM users u
JOIN usage_data ud ON u.user_id = ud.user_id
GROUP BY u.user_id;

-- Device-wise average usage
SELECT d.device_model,
AVG(ud.app_usage_time) AS avg_usage
FROM devices d
JOIN usage_data ud ON d.user_id = ud.user_id
GROUP BY d.device_model
ORDER BY avg_usage DESC;

-- Engagement level count
SELECT engagement_level,
COUNT(*) AS total_users
FROM usage_data
GROUP BY engagement_level;

-- Users above average usage
SELECT u.user_id, ud.app_usage_time
FROM users u
JOIN usage_data ud ON u.user_id = ud.user_id
WHERE ud.app_usage_time >
(SELECT AVG(app_usage_time) FROM usage_data);

-- LEFT JOIN
SELECT u.user_id,
IFNULL(ud.app_usage_time,0) AS usage_time
FROM users u
LEFT JOIN usage_data ud ON u.user_id = ud.user_id;

-- =========================
-- VIEW
-- =========================

CREATE VIEW user_summary AS
SELECT u.user_id, u.gender, d.device_model,
ud.app_usage_time, ud.engagement_level
FROM users u
JOIN devices d ON u.user_id = d.user_id
JOIN usage_data ud ON u.user_id = ud.user_id;

SELECT * FROM user_summary;

-- =========================
-- EXTRA QUERY
-- =========================

SELECT u.user_id,
SUM(ud.app_usage_time) AS total_usage
FROM users u
JOIN usage_data ud ON u.user_id = ud.user_id
GROUP BY u.user_id
ORDER BY total_usage DESC
LIMIT 1;