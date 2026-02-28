from urllib import response
from fastapi import FastAPI, UploadFile, File
from pydantic import BaseModel
from typing import Optional
from fastapi.middleware.cors import CORSMiddleware

from dotenv import load_dotenv
import os  
from google import genai
from ollamafreeapi import OllamaFreeAPI
from google.genai.types import Tool, GoogleSearch, GenerateContentConfig
import PIL
import io

from Backend.schema import MealPlanResponse, UserLocation, Meal_Plan, Receipt, ImageExtract
from Backend.price_data import result_df
from Backend.camera_func.cv_model import run_vision_ocr, extract_items_from_ocr, gemini_vision_identify_count
# from openai import OpenAI

load_dotenv('D:\\KitaHack 2026\\Backend\\GEMINI_API.env')
load_dotenv('D:\\KitaHack 2026\\Backend\\DEEPSK.env')
key = os.getenv('KEY')
dps_key = os.getenv('DEEPSK_KEY')
# print(key)

# Pydantic validation
class Data(BaseModel):
    number: Optional[int] = None
    prompt: str

    
app = FastAPI()

client = genai.Client(api_key=key)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # frontend origin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# @app.post('/double')
# def double(data: Data):
#     return {"result": data.number * 2}


TOPIC_NAME = "Personal Food Management and Dietary Planning"

# ALLOWED_SCOPE = """
# You can answer questions related to:
# - Employment contracts
# - Employee rights and obligations
# - Termination, dismissal, and compensation
# - Industrial Relations Act
# """

REJECTION_MESSAGE = (
    "Sorry, I can only help with questions related to "
    "Personal Food Management and Dietary Planning. Please ask within this scope."
)

def is_relevant(user_query: str, TOPIC_NAME: str) -> bool:
        prompt = f"""
    You are a strict content binary classifier. Classify the following user query based on its relevance to the topic given.
    Topic: {TOPIC_NAME}

    User query:
    \"\"\"{user_query}\"\"\"

    Respond with ONLY one word:
    RELEVANT or IRRELEVANT
    """
    
    # Get instant responses
        response = client.models.generate_content(
            model="gemini-3-flash-preview",
            contents=prompt,
        )
        # print(response) 
        return response.text
    
    


@app.post('/chat')
async def chat(data:Data):
    result = is_relevant(data.prompt, TOPIC_NAME)
    return({'result':result})
    
    
    # response = client.models.generate_content(
    # model="gemini-3-flash-preview", contents=data.prompt
    # )
    # return({'result':response.text})
 




def meal_prompt(meal_type, 
                diet_res, # can set in user configuration
                halal: bool,   # can set in user configuration
                duration, 
                duration_unit,
                meal_purpose,
                num_people,
                budget,
                currency, # can set in user configuration
                skill_level, 
                cook_time, 
                cook_time_unit,
                style,
                variety:bool, 
                health_con,
                ingredients,
                appliances):
    
    
    if halal=='true':
        halal_text = "Ensure all meals are Halal."
    else:
        halal_text = "Not Halal meals are acceptable."
        
    if diet_res:
        diet_text = f"Consider the following recent dietary restrictions: {diet_res}."
    else:
        # diet_text = """There are no recent dietary restrictions. However, you should follow the diet restrictions provided 
        # in the user configuration."""
        diet_text = """There are no recent dietary restrictions."""
    
    if variety:
        variety = "a good"
    else:
        variety = "no"
    
    prompt = f"""
    You are a professional dietitian and chef. Create a {duration} {duration_unit} {meal_type} plan for
    {num_people} people with a budget of {budget} {currency} per meal. 
    
    1) The meal plans is build for {meal_purpose}
    2) The meals should be {style} style and have {variety} variety. {diet_text}
    3) The meals should take approximately {cook_time} {cook_time_unit} to cook and be suitable for {skill_level} skill level cooks.
    4) {halal_text}
    5) Consider the recent health condition when creating the meal plan: {health_con} 
    6) Include these preferred ingredients in the meal plan (Preferred Ingredients List) : {ingredients}
    7) Note that you still may introuduce new ingredients that are not in the Preferred Ingredients List. The newly introduced ingredients
       can only be selected from 'item-price database': {result_df}. 
    8) Make sure the name of ingredients output as English and in general manner, no need to specify the complete names. 
    9) Consider the available cooking tools when creating the meal plan: {appliances} 
    10) Provide a short description within 1 sentence. 
    11) Output the required time to cook for the dish in minutes.
    
   
   Finally, also output all the ingredient ORIGINAL name from 'item-price database' that will be used in the recipes provided.
    
    """
    return(prompt)


tempRecipe = ''

@app.post('/generate')
async def chat(data:Meal_Plan) -> list[MealPlanResponse]:
    prompt = meal_prompt(data.meal_type, 
                data.diet_res, # can set in user configuration
                data.halal,   # can set in user configuration
                data.duration, 
                data.duration_unit,
                data.meal_purpose,
                data.num_people,
                data.budget,
                data.currency, # can set in user configuration
                data.skill_level, 
                data.cook_time, 
                data.cook_time_unit,
                data.style,
                data.variety, 
                data.health_con,
                data.ingredients,
                data.appliances)
    
    response = client.models.generate_content(
    model="gemini-3-flash-preview", contents=prompt,
    config={
        'response_mime_type': 'application/json',
        'response_schema': list[MealPlanResponse],
    }
    )
    # return({'result':response.text})
    tempRecipe = response.parsed
    return(response.parsed)


@app.post('/save-meal-plan')
async def save_meal_plan(save:bool):
    if save: 
        pass
        
    

@app.post('/get-location')
async def receive_location(location: UserLocation):
    # This is where you'd trigger your 8km logic
    print(f"Received coordinates: {location.lat}, {location.lon}")
    
    # Example logic:
    # nearest_shop = find_nearest_shop(location.lat, location.lon)
    
    return {"status": "success", "message": "Location received"}


# Camera feature

@app.post('/extract-receipt')
async def extract_items_from_receipt(file:UploadFile=File()) -> list[Receipt]:
    # 1. Read the image file into bytes
    image_bytes = await file.read()
    
    # 2. Convert bytes to a format Gemini understands (PIL Image)
    img = PIL.Image.open(io.BytesIO(image_bytes))
    
    text_extract = run_vision_ocr(img)
    result = extract_items_from_ocr(text_extract)
    return(result)

@app.post('/extract-item')
async def extract_items_from_image(file:UploadFile=File()) -> list[ImageExtract]:
    # 1. Read the image file into bytes
    image_bytes = await file.read()
    
    # 2. Convert bytes to a format Gemini understands (PIL Image)
    img = PIL.Image.open(io.BytesIO(image_bytes))
    
    result = gemini_vision_identify_count(img)
    return(result)