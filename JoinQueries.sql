/*
 C65 Java Full-Stack with React
 The Software Guild
 Relational Databases and SQL Exercise 4: JOIN Queries
 Russell Taylor
 December 10, 2020
 Written in MySQL
 
 Complete a series of JOIN queries using the PersonalTrainer schema.
 */

USE `PersonalTrainer`;

-- Select all columns from ExerciseCategory and Exercise.
-- The tables should be joined on ExerciseCategoryId.
-- This query returns all Exercises and their associated ExerciseCategory.
-- 64 rows

SELECT * FROM `ExerciseCategory`
  INNER JOIN `Exercise`
    ON `ExerciseCategory`.`ExerciseCategoryID` = `Exercise`.`ExerciseCategoryID`;

-- Select ExerciseCategory.Name and Exercise.Name
-- where the ExerciseCategory does not have a ParentCategoryId (it is null).
-- Again, join the tables on their shared key (ExerciseCategoryId).
-- 9 rows

SELECT `ExerciseCategory`.`Name`, `Exercise`.`Name` FROM `ExerciseCategory`
  INNER JOIN `Exercise`
    ON `ExerciseCategory`.`ExerciseCategoryID` = `Exercise`.`ExerciseCategoryID`
  WHERE `ExerciseCategory`.`ParentCategoryID` IS NULL;
  
-- The query above is a little confusing. At first glance, it's hard to tell
-- which Name belongs to ExerciseCategory and which belongs to Exercise.
-- Rewrite the query using an aliases. 
-- Alias ExerciseCategory.Name as 'CategoryName'.
-- Alias Exercise.Name as 'ExerciseName'.
-- 9 rows

SELECT `ExerciseCategory`.`Name` AS `CategoryName`, `Exercise`.`Name` AS `ExerciseName` FROM `ExerciseCategory`
  INNER JOIN `Exercise`
    ON `ExerciseCategory`.`ExerciseCategoryID` = `Exercise`.`ExerciseCategoryID`
  WHERE `ExerciseCategory`.`ParentCategoryID` IS NULL;

-- Select FirstName, LastName, and BirthDate from Client
-- and EmailAddress from Login 
-- where Client.BirthDate is in the 1990s.
-- Join the tables by their key relationship. 
-- What is the primary-foreign key relationship?
-- 35 rows

SELECT `Client`.`FirstName`, `Client`.`LastName`, `Client`.`BirthDate`, `Login`.`EmailAddress` FROM `Client`
  INNER JOIN `Login`
	ON `Client`.`ClientID` = `Login`.`ClientID`
  WHERE YEAR(`Client`.`BirthDate`) BETWEEN 1990 AND 1999;

-- Select Workout.Name, Client.FirstName, and Client.LastName
-- for Clients with LastNames starting with 'C'?
-- How are Clients and Workouts related?
-- 25 rows

SELECT `Workout`.`Name`, `Client`.`FirstName`, `Client`.`LastName` FROM `Workout`
  INNER JOIN `ClientWorkout`
	ON `Workout`.`WorkoutID` = `ClientWorkout`.`WorkoutID`
  INNER JOIN `Client`
    ON `Client`.`ClientID` = `ClientWorkout`.`ClientID`
  WHERE `Client`.`LastName` LIKE 'C%';

-- Select Names from Workouts and their Goals.
-- This is a many-to-many relationship with a bridge table.
-- Use aliases appropriately to avoid ambiguous columns in the result.

SELECT `Workout`.`Name` AS `WorkoutName`, `Goal`.`Name` AS `GoalName` FROM `Workout`
  INNER JOIN `WorkoutGoal`
    ON `Workout`.`WorkoutID` = `WorkoutGoal`.`WorkoutID`
  INNER JOIN `Goal`
    ON `Goal`.`GoalID` = `WorkoutGoal`.`GoalID`;

-- Select FirstName and LastName from Client.
-- Select ClientId and EmailAddress from Login.
-- Join the tables, but make Login optional.
-- 500 rows

SELECT `Client`.`FirstName`, `Client`.`LastName`, `Login`.`ClientID`, `Login`.`EmailAddress` FROM `Client`
  LEFT OUTER JOIN `Login`
    ON `Client`.`ClientID` = `Login`.`ClientID`;

-- Using the query above as a foundation, select Clients
-- who do _not_ have a Login.
-- 200 rows

SELECT `Client`.`FirstName`, `Client`.`LastName`, `Login`.`ClientID`, `Login`.`EmailAddress` FROM `Client`
  LEFT OUTER JOIN `Login`
    ON `Client`.`ClientID` = `Login`.`ClientID`
  WHERE `Login`.`ClientID` IS NULL;

-- Does the Client, Romeo Seaward, have a Login?
-- Decide using a single query.
-- nope :(

SELECT `Login`.`ClientID`, `Login`.`EmailAddress` FROM `Client`
  LEFT OUTER JOIN `Login`
    ON `Client`.`ClientID` = `Login`.`ClientID`
  WHERE `Client`.`FirstName` = 'Romeo'
    AND `Client`.`LastName` = 'Seaward';

-- Select ExerciseCategory.Name and its parent ExerciseCategory's Name.
-- This requires a self-join.
-- 12 rows

SELECT `ExerciseCategory`.`Name` AS `ExerciseCategory`, `ParentCategory`.`Name` AS `ParentCategory` FROM `ExerciseCategory`
  INNER JOIN `ExerciseCategory` AS `ParentCategory`
	ON `ExerciseCategory`.`ParentCategoryID` = `ParentCategory`.`ExerciseCategoryID`;
    
-- Rewrite the query above so that every ExerciseCategory.Name is
-- included, even if it doesn't have a parent.
-- 16 rows

SELECT `ExerciseCategory`.`Name` AS `ExerciseCategory`, `ParentCategory`.`Name` AS `ParentCategory` FROM `ExerciseCategory`
  LEFT OUTER JOIN `ExerciseCategory` AS `ParentCategory`
	ON `ExerciseCategory`.`ParentCategoryID` = `ParentCategory`.`ExerciseCategoryID`;

-- Are there Clients who are not signed up for a Workout?
-- 50 rows

SELECT COUNT(*) FROM `Client`
  LEFT OUTER JOIN `ClientWorkout`
    ON `Client`.`ClientID` = `ClientWorkout`.`ClientID`
  WHERE `ClientWorkout`.`WorkoutID` IS NULL;

-- Which Beginner-Level Workouts satisfy at least one of Shell Creane's Goals?
-- Goals are associated to Clients through ClientGoal.
-- Goals are associated to Workouts through WorkoutGoal.
-- 6 rows, 4 unique rows

SELECT `Workout`.`Name` FROM `Workout`
  INNER JOIN `WorkoutGoal`
    ON `Workout`.`WorkoutID` = `WorkoutGoal`.`WorkoutID`
  INNER JOIN `Goal`
    ON `Goal`.`GoalID` = `WorkoutGoal`.`GoalID`
  INNER JOIN `ClientGoal`
    ON `Goal`.`GoalID` = `ClientGoal`.`GoalID`
  INNER JOIN `Client`
    ON `Client`.`ClientID` = `ClientGoal`.`ClientID`
  WHERE `Client`.`FirstName` = 'Shell'
    AND `Client`.`LastName` = 'Creane'
    AND `Workout`.`LevelID` = 1;

-- Select all Workouts. 
-- Join to the Goal, 'Core Strength', but make it optional.
-- You may have to look up the GoalId before writing the main query.
-- If you filter on Goal.Name in a WHERE clause, Workouts will be excluded.
-- Why?
-- 26 Workouts, 3 Goals

SELECT * FROM `Workout`
  LEFT OUTER JOIN `WorkoutGoal`
    ON `Workout`.`WorkoutID` = `WorkoutGoal`.`WorkoutID`
      AND `WorkoutGoal`.`GoalID` =
        (SELECT `GoalID` FROM `Goal`
           WHERE `Name` = 'Core Strength')
  LEFT OUTER JOIN `Goal`
    ON `Goal`.`GoalID` = `WorkoutGoal`.`GoalID`;

-- The relationship between Workouts and Exercises is... complicated.
-- Workout links to WorkoutDay (one day in a Workout routine)
-- which links to WorkoutDayExerciseInstance 
-- (Exercises can be repeated in a day so a bridge table is required) 
-- which links to ExerciseInstance 
-- (Exercises can be done with different weights, repetions,
-- laps, etc...) 
-- which finally links to Exercise.
-- Select Workout.Name and Exercise.Name for related Workouts and Exercises.

SELECT `Workout`.`Name`, `Exercise`.`Name` FROM `Workout`
  INNER JOIN `WorkoutDay`
    ON `Workout`.`WorkoutID` = `WorkoutDay`.`WorkoutID`
  INNER JOIN `WorkoutDayExerciseInstance`
    ON `WorkoutDay`.`WorkoutDayID` = `WorkoutDayExerciseInstance`.`WorkoutDayID`
  INNER JOIN `ExerciseInstance`
    ON `WorkoutDayExerciseInstance`.`ExerciseInstanceID` = `ExerciseInstance`.`ExerciseInstanceID`
  INNER JOIN `Exercise`
    ON `ExerciseInstance`.`ExerciseID` = `Exercise`.`ExerciseID`;
    
-- An ExerciseInstance is configured with ExerciseInstanceUnitValue.
-- It contains a Value and UnitId that links to Unit.
-- Example Unit/Value combos include 10 laps, 15 minutes, 200 pounds.
-- Select Exercise.Name, ExerciseInstanceUnitValue.Value, and Unit.Name
-- for the 'Plank' exercise. 
-- How many Planks are configured, which Units apply, and what 
-- are the configured Values?
-- 4 rows, 1 Unit, and 4 distinct Values

SELECT `Exercise`.`Name` AS `ExerciseName`, `ExerciseInstanceUnitValue`.`Value`, `Unit`.`Name` AS `UnitName` FROM `Exercise`
  INNER JOIN `ExerciseInstance`
    ON `Exercise`.`ExerciseID` = `ExerciseInstance`.`ExerciseID`
  LEFT OUTER JOIN `ExerciseInstanceUnitValue`
    ON `ExerciseInstance`.`ExerciseInstanceID` = `ExerciseInstanceUnitValue`.`ExerciseInstanceID`
  LEFT OUTER JOIN `Unit`
    ON `ExerciseInstanceUnitValue`.`UnitID` = `Unit`.`UnitID`
  WHERE `Exercise`.`Name` = 'Plank';
