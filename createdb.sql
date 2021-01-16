-- DROP DATABASE IF EXISTS mealplanner_datastore;
-- CREATE DATABASE mealplanner_datastore;
-- USE DATABASE mealplanner_datastore;
DROP TABLE IF EXISTS
SHOPPING_LIST,
MP_USER,
-- RECIPE,
-- INGREDIENT,
WEEKLY_PLAN,
DAILY_PLAN,
SAVED_RECIPE,
DAILY_PLAN_RECIPE,
SHOPPING_LIST_ENTRY;

DROP TYPE IF EXISTS DIET, ACTIVITY_FACTOR, SEX;

CREATE TYPE DIET AS ENUM ('omni', 'vegan', 'vegetarian', 'glutenFree');

-- You Basal Metabolic Rate (BMR) is equivalent to the amount of energy (in the form of calories) 
-- that your body needs to function if it were to rest for 24 hours.
-- How can you calculate your BMR?
--     For men: BMR = 10 x weight (kg) + 6.25 x height (cm) – 5 x age (years) + 5
--     For women: BMR = 10 x weight (kg) + 6.25 x height (cm) – 5 x age (years) – 161
-- Sedentary (little or no exercise) : Calorie-Calculation = BMR x 1.2
-- Lightly active (light exercise/sports 1-3 days/week) : Calorie-Calculation = BMR x 1.375
-- Moderately active (moderate exercise/sports 3-5 days/week) : Calorie-Calculation = BMR x 1.55
-- Very active (hard exercise/sports 6-7 days a week) : Calorie-Calculation = BMR x 1.725
-- If you are extra active (very hard exercise/sports & a physical job) : Calorie-Calculation = BMR x 1.9
CREATE TYPE ACTIVITY_FACTOR AS ENUM ('none', 'light', 'moderate', 'very', 'extra');
CREATE TYPE SEX AS ENUM ('m', 'f');


CREATE TABLE SHOPPING_LIST (
    shopping_list_id SERIAL UNIQUE NOT NULL,
    PRIMARY KEY(shopping_list_id)
);

CREATE TABLE MP_USER (
    mp_user_id SERIAL UNIQUE NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    height INT,
    weight INT,
    sex SEX,
    birth_year INT,
    diet_type DIET,
    activity_factor ACTIVITY_FACTOR,
    address VARCHAR(255),
    shopping_list_id INT,
    current_weekly_plan_id INT,
    PRIMARY KEY(mp_user_id),
    
    CONSTRAINT fk_shopping_list_id
        FOREIGN KEY(shopping_list_id)
            REFERENCES SHOPPING_LIST(shopping_list_id)
);

-- CREATE TABLE RECIPE (
--     recipe_id SERIAL UNIQUE NOT NULL,
--     PRIMARY KEY(recipe_id)
-- );

-- CREATE TABLE INGREDIENT (
--     ingredient_id SERIAL UNIQUE NOT NULL,
--     PRIMARY KEY(ingredient_id)
-- );

CREATE TABLE WEEKLY_PLAN (
    weekly_plan_id SERIAL UNIQUE NOT NULL,
    mp_user_id INT,
    is_current BOOLEAN,
    PRIMARY KEY(weekly_plan_id),
    CONSTRAINT fk_mp_user_id
        FOREIGN KEY(mp_user_id)
            REFERENCES MP_USER(mp_user_id)
);

ALTER TABLE MP_USER
ADD CONSTRAINT fk_weekly_plan_id
   FOREIGN KEY (current_weekly_plan_id)
   REFERENCES WEEKLY_PLAN(weekly_plan_id);

CREATE TABLE DAILY_PLAN (
    daily_plan_id SERIAL UNIQUE NOT NULL,
    weekly_plan_id INT,
    PRIMARY KEY(daily_plan_id),
    CONSTRAINT fk_weekly_plan_id
        FOREIGN KEY(weekly_plan_id)
            REFERENCES WEEKLY_PLAN(weekly_plan_id)
);


CREATE TABLE SAVED_RECIPE (
    mp_user_id INT,
    recipe_id INT,
    CONSTRAINT fk_mp_user_id
        FOREIGN KEY(mp_user_id)
            REFERENCES MP_USER(mp_user_id),
    PRIMARY KEY(mp_user_id, recipe_id)
);

CREATE TABLE DAILY_PLAN_RECIPE (
    daily_plan_id INT,
    recipe_id INT,
    CONSTRAINT fk_daily_plan_id
        FOREIGN KEY(daily_plan_id)
            REFERENCES DAILY_PLAN(daily_plan_id),
    PRIMARY KEY (daily_plan_id, recipe_id)
);

CREATE TABLE SHOPPING_LIST_ENTRY(
    shopping_list_entry_id SERIAL UNIQUE NOT NULL,
    shopping_list_id INT,
    ingredient_id INT,
    quantity VARCHAR(255),
    CONSTRAINT fk_shopping_list_id
        FOREIGN KEY(shopping_list_id)
            REFERENCES SHOPPING_LIST(shopping_list_id),
    PRIMARY KEY (shopping_list_entry_id)
);
