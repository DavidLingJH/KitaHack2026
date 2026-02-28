# from dotenv import load_dotenv
# import os 

# load_dotenv('D:\\KitaHack 2026\\Backend\\GEMINI_API.env')
# key = os.getenv('KEY')
# # print(key)
# from google import genai

# # The client gets the API key from the environment variable `GEMINI_API_KEY`.
# client = genai.Client(api_key=key)

# response = client.models.generate_content(
#     model="gemini-3-flash-preview", contents="Hello"
# )
# print(response.text)

import os 
from dotenv import load_dotenv
from schema import MealPlanResponse
from google import genai


load_dotenv('D:\\KitaHack 2026\\Backend\\GEMINI_API.env')
load_dotenv('D:\\KitaHack 2026\\Backend\\DEEPSK.env')
key = os.getenv('KEY')

client = genai.Client(api_key=key)

ingred = {'AYAM BERSIH - STANDARD': 'CLEAN CHICKEN - STANDARD',
 'AYAM BERSIH - SUPER': 'SUPER-CLEAN CHICKEN',
 'IKAN CENCARU (ANTARA 4 HINGGA 6 EKOR SEKILOGRAM)': 'CUTTLEFISH (BETWEEN 4 AND 6 SEKILOGRAM)',
 'IKAN KEMBUNG KECIL/PELALING (ANTARA 10 HINGGA 18 EKOR SEKILOGRAM)': 'SMALL MACKEREL/PELALING (BETWEEN 10 AND 18 SEKILOGRAM)',
 'IKAN SELAR KUNING (b\t% 11 EKOR SEKILOGRAM)': 'YELLOW SNAKEFISH (b    % 11 SEKILOGRAM)',
 'IKAN SELAR PELATA (≤ 7 EKOR SEKILOGRAM)': 'PELATA FISH (≤ 7 SEKILOGRAM)',
 'IKAN KELI (ANTARA 2 HINGGA 5 EKOR SEKILOGRAM)': 'CATFISH (BETWEEN 2 AND 5 SEKILOGRAM)',
 'CILI HIJAU': 'green chilli',
 'CILI MERAH - KULAI': 'RED CHILLI - KULAI',
 'CILI MERAH - MINYAK': 'RED CHILLI - OIL',
 'HALIA BASAH (TUA)': 'WET GINGER (OLD)',
 'KACANG BENDI': 'peanuts',
 'KACANG BUNCIS': 'COMMON BEAN',
 'KACANG PANJANG': 'Vigna unguiculata subsp. sesquipedalis',
 'KUBIS BULAT IMPORT (CHINA)': 'IMPORTED ROUND CABBAGE (CHINA)',
 'KUBIS BULAT (TEMPATAN)': 'ROUND CABBAGE (LOCAL)',
 'KUNYIT HIDUP': '',
 'LOBAK MERAH': 'Carrot',
 'TIMUN': 'Cucumber',
 'TOMATO': 'Tomato',
 'BAWANG BESAR KUNING/HOLLAND': 'YELLOW ONION/HOLLAND',
 'BAWANG KECIL MERAH ROSE IMPORT (INDIA)': 'RED ONION ROSE IMPORT (INDIA)',
 'BAWANG KECIL MERAH IMPORT (THAILAND)': 'IMPORTED SHALLOTS (THAILAND)',
 'SOTONG (≥ 6 EKOR SEKILOGRAM)': 'SQUID (≥ 6 SEKILOGRAM)',
 'KETAM RENJONG/BUNGA (ANTARA 5 HINGGA 8 EKOR SEKILOGRAM)': 'RENJONG CRABS/FLOWERS (BETWEEN 5 TO 8 SEKILOGRAM)',
 'UBI KENTANG HOLLAND': 'HOLLAND POTATO',
 'NESCAFE CLASSIC (PAKET)': 'NESCAFÉ CLASSIC (PACKAGE)',
 'TELUR AYAM GRED A': 'A GRADE CHICKEN EGG',
 'TELUR AYAM GRED B': 'GRADE B CHICKEN EGGS',
 'TELUR AYAM GRED C': 'GRADE C CHICKEN EGGS',
 'UBI KENTANG IMPORT (CHINA)': 'IMPORTED POTATOES (CHINA)',
 'LIMAU NIPIS': 'Key lime',
 'IKAN KERISI (ANTARA 5 HINGGA 10 EKOR SEKILOGRAM)': 'CRACKER FISH (BETWEEN 5 AND 10 SEKILOGRAM)',
 'BAWANG BESAR IMPORT (INDIA)': 'IMPORTED ONION (INDIA)',
 'BAWANG BESAR IMPORT (CHINA)': 'IMPORTED ONIONS (CHINA)',
 'BAWANG KECIL MERAH BIASA IMPORT (INDIA)': 'IMPORTED COMMON SHALLOT (INDIA)',
 'BAWANG KECIL MERAH IMPORT (CHINA)': 'IMPORTED SHALLOTS (CHINA)',
 'BAWANG KECIL MERAH IMPORT (MYANMAR)': 'IMPORTED SHALLOTS (MYANMAR)',
 'KUBIS BULAT IMPORT (BEIJING)': 'IMPORTED ROUND CABBAGE (BEIJING)',
 'IKAN BAWAL PUTIH (ANTARA 2 HINGGA 5 EKOR SEKILOGRAM)': 'CARP (BETWEEN 2 AND 5 SEKILOGRAM)',
 'IKAN KEMBUNG (ANTARA 8 HINGGA 12 EKOR SEKILOGRAM)': 'MACKEREL (BETWEEN 8 AND 12 SEKILOGRAM)',
 'IKAN MABUNG (ANTARA 6 HINGGA 10 EKOR SEKILOGRAM)': 'MABUNG FISH (BETWEEN 6 AND 10 SEKILOGRAM)',
 'KUBIS BUNGA (CAULIFLOWER)': 'CAULIFLOWER',
 'UDANG PUTIH/VANNAMEI (TERNAK) (ANTARA 41 HINGGA 60 EKOR SEKILOGRAM)': 'WHITE SHRIMP/VANNAMEI (LIVESTOCK) (BETWEEN 41 AND 60 SEKILOGRAM)',
 'BAYAM HIJAU': 'Amaranthus tricolor',
 'SAWI HIJAU': 'GREEN MUSTARD',
 'KANGKUNG': 'vegetable shoots sweet potato',
 'KAILAN': 'HOOK',
 'BAWANG PUTIH IMPORT (CHINA)': 'IMPORTED GARLIC (CHINA)',
 'BERAS SUPER CAP JATI TWR  5% (IMPORT)': 'SUPER CAP RICE TEAK TWR  5% (IMPORT)',
 'LENGKUAS': 'Alpinia galanga',
 'IKAN DEMUDUK/CUPAK/CERMIN (b\t$ 3 EKOR SEKILOGRAM)': 'DEMUDUK FISH/CUPAK/MIRROR (b    $3 SEKILOGRAM)',
 'IKAN TILAPIA MERAH (ANTARA 2 HINGGA 5 EKOR SEKILOGRAM)': 'RED TILAPIA (BETWEEN 2 AND 5 SEKILOGRAM)',
 'CILI AKAR HIJAU': 'GREEN ROOT CHILI',
 'CILI AKAR MERAH': 'RED ROOT CHILI',
 'LIMAU KASTURI': 'Calamondin',
 'BAWANG BESAR IMPORT (PAKISTAN)': 'IMPORTED ONION (PAKISTAN)'}


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
       can only be selected from {ingred}
    8) Make sure the name of ingredients output as English and in general manner, no need to specify the complete names. 
    9) Consider the available cooking tools when creating the meal plan: {appliances} 
    
    
   
   Finally, also output all the ingredient ORIGINAL name from {ingred} that will be used in the recipes provided.
    
    """
    return(prompt)
    
    

    
# response = client.models.generate_content(
# model="gemini-3-flash-preview", contents='List a few Malaysian food recipe for 3 days lunch plan and include the amount of the ingredients. Give me different recipe for each day',
# config={
#     'response_mime_type': 'application/json',
#     'response_schema': list[MealPlanResponse],
# }
# )


response = client.models.generate_content(
model="gemini-3-flash-preview", contents=meal_prompt('dinner'
                                                     ,'No Peanut and Prawn',
                                                     True,
                                                     1,
                                                     'hour',
                                                     'lose weight',
                                                     3,
                                                     50,
                                                     'MYR',
                                                     'Intermediate',
                                                     1,
                                                     'hour',
                                                     'Malaysian',
                                                    True,
                                                    'Currently having some flu',
                                                    'Egg, Fish and Chicken',
                                                    'Frying Pan, induction cooker and Microwave'),
config={
    'response_mime_type': 'application/json',
    'response_schema': list[MealPlanResponse],
}
)

print(response.text)