import sys
import os
import io
from pathlib import Path
import PIL.Image

# Google SDKs
from google.cloud import vision
from google import genai
# Note: Ensure you have google-cloud-vision and google-genai installed

# 1. PATH REPAIRS: Making it work on Mac & Windows
# This identifies the folder where cv_model.py actually sits
BASE_DIR = Path(__file__).resolve().parent 
PROJECT_ROOT = BASE_DIR.parent.parent # Goes up to KitaHack2026

# Add Project Root to sys.path so 'import schema' works regardless of where you run it
if str(PROJECT_ROOT) not in sys.path:
    sys.path.append(str(PROJECT_ROOT))

from Backend import schema # Assuming your structure is Backend/schema.py

# 2. CREDENTIALS
# We build the path dynamically so it uses / on Mac and \ on Windows automatically
VISION_JSON_PATH = BASE_DIR / "vision.json" 

os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = str(VISION_JSON_PATH)
# Pro-tip: Generally, don't hardcode API keys in code. Use .env!
os.environ["GEMINI_API_KEY"] = "AIzaSyC0DrPoAMbeIIBkC5ltOCZiKIPe0_Jgs8c"

GEMINI_KEY = os.getenv('GEMINI_API_KEY')

# Debugging Prints
print(f"[*] System: Running on {sys.platform}")
print(f"[*] Auth: Looking for Vision JSON at: {VISION_JSON_PATH}")
print(f"[*] Auth: File exists? {VISION_JSON_PATH.exists()}")

client = genai.Client(api_key=GEMINI_KEY)

# --- OCR METHODS ---

def run_vision_ocr(pil_image: PIL.Image.Image) -> str:
    """Extract text from a PIL Image object using Google Cloud Vision."""
    print("[*] Scanning Receipt via Google Cloud Vision...")
    
    try:
        vision_client = vision.ImageAnnotatorClient()

        # Convert PIL Image to Bytes
        img_byte_arr = io.BytesIO()
        pil_image.save(img_byte_arr, format='PNG') 
        content = img_byte_arr.getvalue()

        image = vision.Image(content=content)
        response = vision_client.document_text_detection(image=image)
        
        if response.error.message:
            raise Exception(f"Vision API Error: {response.error.message}")

        text = response.full_text_annotation.text
        print(f"[+] OCR Success. Extracted {len(text)} characters.")
        return text
    except Exception as e:
        print(f"[-] OCR Failed: {e}")
        return ""

def extract_items_from_ocr(ocr_text: str):
    """Uses Gemini to parse raw OCR text into a structured list of food items."""
    if not ocr_text: return []
    print("[*] Parsing receipt text with Gemini...")

    prompt = f"""
    Extract FOOD items from this receipt text. 
    Return the items as a JSON list matching the schema.
    Ignore taxes, totals, or non-food items.
    
    OCR TEXT:
    {ocr_text}
    """
    try:
        resp = client.models.generate_content(
            model="gemini-2.5-flash", 
            contents=prompt, 
            config={
                'response_mime_type': 'application/json',
                'response_schema': list[schema.Receipt],
            }
        )
        return resp.parsed
    except Exception as e:
        print(f"[-] Gemini Parsing Error: {e}")
        return []

def gemini_vision_identify_count(image: PIL.Image.Image):
    """Identifies and counts grocery items directly from a photo using Gemini Vision."""
    print(f"[*] Analyzing image content with Gemini Vision...")
    
    prompt = "Identify all FOOD items in this photo and count them."
    
    try:
        resp = client.models.generate_content(
            model="gemini-2.5-flash", 
            contents=[image, prompt], 
            config={
                'response_mime_type': 'application/json',
                'response_schema': list[schema.ImageExtract],
            }
        )
        return resp.parsed
    except Exception as e:
        print(f"[-] Gemini Vision Error: {e}")
        return []