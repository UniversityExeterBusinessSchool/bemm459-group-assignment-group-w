SELECT name FROM sys.databases;
-- ============================================
-- STEP 1: Delete tables if they already exist
-- (Order matters because of foreign keys)
-- ============================================

DROP TABLE IF EXISTS WatchHistory_A;
DROP TABLE IF EXISTS Subscriptions_A;
DROP TABLE IF EXISTS Content_A;
DROP TABLE IF EXISTS Users_A;
-- ============================================
-- STEP 2: Create Users_A table
-- Stores user information for the platform
-- ============================================

CREATE TABLE Users_A (
    UserID INT PRIMARY KEY,          -- Unique ID for each user
    FullName VARCHAR(100),           -- Full name of the user
    Email VARCHAR(100),              -- Email address
    Country VARCHAR(50),             -- Country of the user
    JoinDate DATE                   -- Date the user joined
);
SELECT * FROM Users_A;
-- ============================================
-- STEP 3: Insert sample data into Users_A
-- ============================================

INSERT INTO Users_A VALUES (1, 'Alice Smith', 'alice@example.com', 'UK', '2023-01-10');
INSERT INTO Users_A VALUES (2, 'Bob Jones', 'bob@example.com', 'USA', '2023-02-15');
INSERT INTO Users_A VALUES (3, 'Charlie Brown', 'charlie@example.com', 'Canada', '2023-03-20');
INSERT INTO Users_A VALUES (4, 'David Lee', 'david@example.com', 'UK', '2023-04-25');
INSERT INTO Users_A VALUES (5, 'Emma Wilson', 'emma@example.com', 'Australia', '2023-05-30');
-- Check inserted data
SELECT * FROM Users_A;
-- ============================================
-- STEP 4: Create Content_A table
-- Stores movies and TV shows
-- ============================================

CREATE TABLE Content_A (
    ContentID INT PRIMARY KEY,       -- Unique ID for each content item
    Title VARCHAR(100),              -- Name of the movie/show
    Type VARCHAR(50),                -- Movie or Show
    ReleaseYear INT,                 -- Year of release
    Duration INT                    -- Duration in minutes
);
SELECT * FROM Content_A;
-- ============================================
-- STEP 5: Insert sample content data
-- ============================================

INSERT INTO Content_A VALUES (1, 'Inception', 'Movie', 2010, 148);
INSERT INTO Content_A VALUES (2, 'Stranger Things', 'Show', 2016, 50);
INSERT INTO Content_A VALUES (3, 'The Matrix', 'Movie', 1999, 136);
INSERT INTO Content_A VALUES (4, 'Breaking Bad', 'Show', 2008, 47);
INSERT INTO Content_A VALUES (5, 'Interstellar', 'Movie', 2014, 169);
-- Check inserted data
SELECT * FROM Content_A;
SELECT * FROM Content_A;
-- ============================================
-- STEP 6: Create Subscriptions_A table
-- Stores subscription details for each user
-- ============================================

CREATE TABLE Subscriptions_A (
    SubscriptionID INT PRIMARY KEY,  -- Unique subscription ID
    UserID INT,                      -- Links to Users_A table
    PlanType VARCHAR(50),            -- Basic or Premium plan
    Price DECIMAL(5,2),              -- Price of subscription
    StartDate DATE,                  -- Subscription start date

    -- Foreign Key (IMPORTANT)
    FOREIGN KEY (UserID) REFERENCES Users_A(UserID)
);
-- ============================================
-- STEP 7: Insert subscription data
-- ============================================

INSERT INTO Subscriptions_A VALUES (1, 1, 'Basic', 9.99, '2025-01-01');
INSERT INTO Subscriptions_A VALUES (2, 2, 'Basic', 9.99, '2025-01-05');
INSERT INTO Subscriptions_A VALUES (3, 3, 'Premium', 14.99, '2025-01-10');
INSERT INTO Subscriptions_A VALUES (4, 4, 'Basic', 9.99, '2025-01-15');
INSERT INTO Subscriptions_A VALUES (5, 5, 'Premium', 14.99, '2025-01-20');
SELECT * FROM Subscriptions_A;
-- ============================================
-- STEP 8: Create WatchHistory_A table
-- Tracks what each user watched
-- ============================================

CREATE TABLE WatchHistory_A (
    WatchID INT PRIMARY KEY,         -- Unique watch record ID
    UserID INT,                      -- Links to Users_A
    ContentID INT,                   -- Links to Content_A
    WatchDate DATE,                  -- Date watched

    -- Foreign Keys (VERY IMPORTANT)
    FOREIGN KEY (UserID) REFERENCES Users_A(UserID),
    FOREIGN KEY (ContentID) REFERENCES Content_A(ContentID)
);
-- ============================================
-- STEP 9: Insert watch history data
-- ============================================

INSERT INTO WatchHistory_A VALUES (1, 1, 1, '2025-02-01');
INSERT INTO WatchHistory_A VALUES (2, 2, 2, '2025-02-02');
INSERT INTO WatchHistory_A VALUES (3, 3, 3, '2025-02-03');
INSERT INTO WatchHistory_A VALUES (4, 4, 4, '2025-02-04');
INSERT INTO WatchHistory_A VALUES (5, 5, 5, '2025-02-05');
-- Check if data inserted correctly
SELECT * FROM WatchHistory_A;
-- ============================================
-- QUERY 1: Show user names and what they watched
-- Demonstrates JOIN between multiple tables
-- ============================================

SELECT 
    Users_A.FullName,        -- User name
    Content_A.Title,         -- Content watched
    WatchHistory_A.WatchDate -- Date watched

FROM WatchHistory_A

-- Join with Users table
JOIN Users_A 
ON WatchHistory_A.UserID = Users_A.UserID

-- Join with Content table
JOIN Content_A 
ON WatchHistory_A.ContentID = Content_A.ContentID;
-- ============================================
-- QUERY 2: Find most watched content
-- Uses COUNT and GROUP BY
-- ============================================

SELECT 
    Content_A.Title,                  -- Content name
    COUNT(WatchHistory_A.WatchID) AS WatchCount  -- Number of times watched

FROM WatchHistory_A

-- Join with Content table
JOIN Content_A 
ON WatchHistory_A.ContentID = Content_A.ContentID

GROUP BY Content_A.Title;
-- ============================================
-- QUERY 3: Find users with Premium subscription
-- Uses JOIN + WHERE (filtering)
-- ============================================

SELECT 
    Users_A.FullName,       -- User name
    Subscriptions_A.PlanType, -- Type of plan
    Subscriptions_A.Price    -- Subscription price

FROM Subscriptions_A

-- Join with Users table
JOIN Users_A 
ON Subscriptions_A.UserID = Users_A.UserID

-- Filter only Premium users
WHERE Subscriptions_A.PlanType = 'Premium';
-- ============================================
-- QUERY 4: Find most active users
-- Uses COUNT, GROUP BY, ORDER BY
-- ============================================

SELECT 
    Users_A.FullName,                         -- User name
    COUNT(WatchHistory_A.WatchID) AS TotalWatched  -- Number of items watched

FROM WatchHistory_A

-- Join with Users table
JOIN Users_A 
ON WatchHistory_A.UserID = Users_A.UserID

GROUP BY Users_A.FullName

-- Sort from highest to lowest
ORDER BY TotalWatched DESC;