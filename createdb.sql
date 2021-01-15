-- DROP DATABASE IF EXISTS mealplanner_datastore;
-- CREATE DATABASE mealplanner_datastore;
-- USE DATABASE mealplanner_datastore;
DROP TABLE IF EXISTS
MP_USER,
RECIPE,
INGREDIENT,
WEEKLY_PLAN,
DAILY_PLAN,
SHOPPING_LIST,
SAVED_RECIPE,
DAILY_PLAN_RECIPE,
SHOPPING_LIST_INGREDIENT;

DROP TYPE IF EXISTS DIET;

CREATE TYPE DIET AS ENUM ('omni', 'vegan', 'vegetarian', 'glutenFree');

CREATE TABLE SHOPPING_LIST (
    shopping_list_id SERIAL UNIQUE NOT NULL,
    PRIMARY KEY(shopping_list_id)
);

CREATE TABLE MP_USER (
    mp_user_id SERIAL UNIQUE NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    height INT,
    weight INT,
    diet_type DIET,
    address VARCHAR(255),
    shopping_list_id INT,
    PRIMARY KEY(mp_user_id),
    
    CONSTRAINT shopping_list_id
        FOREIGN KEY(shopping_list_id)
            REFERENCES SHOPPING_LIST(shopping_list_id)
);

CREATE TABLE RECIPE (
    recipe_id SERIAL UNIQUE NOT NULL,
    PRIMARY KEY(recipe_id)
);

CREATE TABLE INGREDIENT (
    ingredient_id SERIAL UNIQUE NOT NULL,
    PRIMARY KEY(ingredient_id)
);

CREATE TABLE WEEKLY_PLAN (
    weekly_plan_id SERIAL UNIQUE NOT NULL,
    mp_user_id INT,
    PRIMARY KEY(weekly_plan_id),
    CONSTRAINT mp_user_id
        FOREIGN KEY(mp_user_id)
            REFERENCES MP_USER(mp_user_id)
);

CREATE TABLE DAILY_PLAN (
    daily_plan_id SERIAL UNIQUE NOT NULL,
    weekly_plan_id INT,
    PRIMARY KEY(daily_plan_id),
    CONSTRAINT weekly_plan_id
        FOREIGN KEY(weekly_plan_id)
            REFERENCES WEEKLY_PLAN(weekly_plan_id)
);


CREATE TABLE SAVED_RECIPE (
    mp_user_id INT,
    recipe_id INT,
    CONSTRAINT mp_user_id
        FOREIGN KEY(mp_user_id)
            REFERENCES MP_USER(mp_user_id),
    PRIMARY KEY(mp_user_id, recipe_id)
);

CREATE TABLE DAILY_PLAN_RECIPE (
    daily_plan_id INT,
    recipe_id INT,
    CONSTRAINT daily_plan_id
        FOREIGN KEY(daily_plan_id)
            REFERENCES DAILY_PLAN(daily_plan_id),
    PRIMARY KEY (daily_plan_id, recipe_id)
);

CREATE TABLE SHOPPING_LIST_INGREDIENT (
    shopping_list_id INT,
    ingredient_id INT,
    quantity VARCHAR(255),
    CONSTRAINT shopping_list_id
        FOREIGN KEY(shopping_list_id)
            REFERENCES SHOPPING_LIST(shopping_list_id),
    PRIMARY KEY (shopping_list_id, ingredient_id)
);
