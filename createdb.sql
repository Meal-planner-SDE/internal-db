-- DROP DATABASE IF EXISTS mealplanner_datastore;
-- CREATE DATABASE mealplanner_datastore;
-- USE DATABASE mealplanner_datastore;
DROP TABLE IF EXISTS
SHOPPING_LIST,
MP_USER,
-- RECIPE,
-- INGREDIENT,
MEAL_PLAN,
DAILY_PLAN,
SAVED_RECIPE,
DAILY_PLAN_RECIPE,
SHOPPING_LIST_ENTRY;

DROP TYPE IF EXISTS DIET, ACTIVITY_FACTOR, SEX, MEASURE;

DROP FUNCTION IF EXISTS delete_zero_shopping_list_entries;
-- DROP TRIGGER IF EXISTS trigger_delete_zero_shopping_list_entries ON SHOPPING_LIST_ENTRY;

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
CREATE TYPE MEASURE AS ENUM ('g', 'ml');


CREATE TABLE SHOPPING_LIST (
    shopping_list_id SERIAL UNIQUE NOT NULL,
    PRIMARY KEY(shopping_list_id)
);

CREATE TABLE MP_USER (
    mp_user_id SERIAL UNIQUE NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    height INT NOT NULL,
    weight INT NOT NULL,
    sex SEX NOT NULL,
    birth_year INT NOT NULL,
    diet_type DIET NOT NULL,
    activity_factor ACTIVITY_FACTOR NOT NULL,
    address VARCHAR(255),
    shopping_list_id INT NOT NULL,
    current_meal_plan_id INT,
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

CREATE TABLE MEAL_PLAN (
    meal_plan_id SERIAL UNIQUE NOT NULL,
    mp_user_id INT NOT NULL,
    is_current BOOLEAN NOT NULL DEFAULT TRUE,
    daily_calories INT,
    diet_type DIET,

    PRIMARY KEY(meal_plan_id),
    CONSTRAINT fk_mp_user_id
        FOREIGN KEY(mp_user_id)
            REFERENCES MP_USER(mp_user_id) ON DELETE CASCADE
);

ALTER TABLE MP_USER
ADD CONSTRAINT fk_meal_plan_id
   FOREIGN KEY (current_meal_plan_id)
   REFERENCES MEAL_PLAN(meal_plan_id) ON DELETE SET NULL;

CREATE TABLE DAILY_PLAN (
    daily_plan_id SERIAL UNIQUE NOT NULL,
    meal_plan_id INT NOT NULL,
    daily_plan_number INT NOT NULL, --The ith day of the plan
    PRIMARY KEY(daily_plan_id),
    CONSTRAINT fk_meal_plan_id
        FOREIGN KEY(meal_plan_id)
            REFERENCES MEAL_PLAN(meal_plan_id) ON DELETE CASCADE
);

CREATE TABLE DAILY_PLAN_RECIPE (
    daily_plan_id INT NOT NULL,
    recipe_id INT NOT NULL,
    recipe_number INT NOT NULL, --The ith recipe of the day
    CONSTRAINT fk_daily_plan_id
        FOREIGN KEY(daily_plan_id)
            REFERENCES DAILY_PLAN(daily_plan_id) ON DELETE CASCADE,
    PRIMARY KEY (daily_plan_id, recipe_id)
);

CREATE TABLE SAVED_RECIPE (
    mp_user_id INT NOT NULL,
    recipe_id INT NOT NULL,
    CONSTRAINT fk_mp_user_id
        FOREIGN KEY(mp_user_id)
            REFERENCES MP_USER(mp_user_id),
    PRIMARY KEY(mp_user_id, recipe_id)
);

CREATE TABLE SHOPPING_LIST_ENTRY(
    shopping_list_entry_id SERIAL UNIQUE NOT NULL,
    shopping_list_id INT NOT NULL,
    ingredient_id INT NOT NULL UNIQUE,
    quantity INT NOT NULL,
    measure MEASURE NOT NULL,
    CONSTRAINT fk_shopping_list_id
        FOREIGN KEY(shopping_list_id)
            REFERENCES SHOPPING_LIST(shopping_list_id) ON DELETE CASCADE,
    PRIMARY KEY (shopping_list_entry_id)
);

CREATE FUNCTION delete_zero_shopping_list_entries() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
        DELETE FROM SHOPPING_LIST_ENTRY WHERE quantity <= 0;
        RETURN NULL;
        END;
    $$;

CREATE TRIGGER trigger_delete_zero_shopping_list_entries
    AFTER UPDATE ON SHOPPING_LIST_ENTRY
    EXECUTE PROCEDURE delete_zero_shopping_list_entries();