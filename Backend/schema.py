from pydantic import BaseModel, Field, ConfigDict, EmailStr
from typing import Optional, Literal
from datetime import datetime


# schema for receipt extraction

class Receipt(BaseModel):
    name:str
    quantity:int
    price:float
    
# schema for image extraction

class ImageExtract(BaseModel):
    name:str
    quantity:int|float

class Meal_Plan(BaseModel):
    meal_type: str 
    diet_res: str # can set in user configuration
    halal: bool # can set in user configuration
    duration: int
    duration_unit: str
    meal_purpose: str
    num_people:int
    budget:int|float
    currency: str # can set in user configuration
    skill_level: str
    cook_time: int | float 
    cook_time_unit: str
    style: str
    variety:bool
    health_con: str
    ingredients: str
    appliances: str

# LLM output schema 

class Recipe(BaseModel):
    Day:int
    Meal_name:str
    description:str
    Ingredients:list[str]
    Steps:list[str]
    time_required: int
    difficulty: Literal['Beginner', 'Intermediate', 'Advanced']
    calories:int
    
class ShoppingItem(BaseModel):
    item_code: int
    item_name : str
    premise_code:int
    
class MealPlanResponse(BaseModel):
    recipe: Recipe
    shopping_list: list[ShoppingItem]
    cost: int|float
    
class UserLocation(BaseModel):
    lat: float
    lon: float
    
    
    

