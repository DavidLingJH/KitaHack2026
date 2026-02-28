import sys
import os
from google.cloud import vision
from google import genai
import PIL
import io

parent_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
sys.path.append(parent_dir)
import schema

os.environ["GEMINI_API_KEY"] = "AIzaSyC0DrPoAMbeIIBkC5ltOCZiKIPe0_Jgs8c"
os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = r"Backend\camera_func\vision.json"

VISION_CREDENTIALS = os.getenv('GOOGLE_APPLICATION_CREDENTIALS')
GEMINI_KEY = os.getenv('GEMINI_API_KEY')


print(f"Python Executable: {sys.executable}")
print(f"GOOGLE_APPLICATION_CREDENTIALS: {os.getenv('GOOGLE_APPLICATION_CREDENTIALS')}")
print(f"GEMINI_API_KEY set: {os.getenv('GEMINI_API_KEY') is not None}")

client = genai.Client(api_key=GEMINI_KEY)

# OCR method to extract info from receipt
def run_vision_ocr(pil_image: PIL.Image.Image) -> str:
    """Extract text from a PIL Image object."""
    print("[*] Scanning Receipt from PIL Image...")
    
    client = vision.ImageAnnotatorClient()

    # 1. Convert PIL Image to Bytes for Google Vision
    img_byte_arr = io.BytesIO()
    # Use PNG or JPEG depending on your input
    pil_image.save(img_byte_arr, format='PNG') 
    content = img_byte_arr.getvalue()

    # 2. Prepare the Vision Image object
    image = vision.Image(content=content)
    
    # 3. Perform OCR
    response = client.document_text_detection(image=image)
    
    if response.error.message:
        raise Exception(f"Vision API Error: {response.error.message}")

    text = response.full_text_annotation.text
    print(f"[+] OCR Success. Extracted {len(text)} chars.")
    return text

def extract_items_from_ocr(ocr_text: str):
    if not ocr_text: return []
    print("[*] Parsing with Gemini (Text)...")
    # model = genai.GenerativeModel('gemini-2.5-flash')
    prompt = f"""
    Extract FOOD items from this receipt text.
    Ignore non-food.
    OCR TEXT:
    {ocr_text}
    """
    try:
        resp = client.models.generate_content(model="gemini-2.5-flash", contents = prompt, 
                                               config={
                                                        'response_mime_type': 'application/json',
                                                        'response_schema': list[schema.Receipt],
                                                        }
        )
        # data = extract_json_from_text(resp.text)
        # items = data.get("items", []) if data else []
        # print(f"[+] Extracted {len(items)} items.")
        return(resp.parsed)
    except Exception as e:
        print(f"[-] Error: {e}")
        return []


def gemini_vision_identify_count(image: PIL.Image.Image):
    """Identifies and counts grocery items in a photo."""
    print(f"[*] AI Eyes: Analyzing image...")
    
    prompt = """
    Identify all FOOD items in this photo.
    Count them.
    """
    try:
        resp = client.models.generate_content(model="gemini-2.5-flash", contents = [image, prompt], 
                                               config={
                                                        'response_mime_type': 'application/json',
                                                        'response_schema': list[schema.ImageExtract],
                                                        }
    )
        
        # data = extract_json_from_text(resp.text)
        # items = data.get("items", []) if data else []
        # print(f"[+] Vision found {len(items)} distinct item types.")
        return(resp.parsed)
    except Exception as e:
        print(f"[-] Vision Error: {e}")
        return []



# Test Case

# # OCR method to extract info from receipt
# def run_vision_ocr(image_path: str) -> str:
#     """Extract text from receipt image."""
#     print(f"[*] Scanning Receipt: {image_path}...")
#     if not os.path.exists(image_path):
#         print(f"Error: File {image_path} not found.")
#         return ""
        
#     client = vision.ImageAnnotatorClient()
#     with open(image_path, 'rb') as f:
#         content = f.read()
#     image = vision.Image(content=content)
#     response = client.document_text_detection(image=image)
    
#     text = response.full_text_annotation.text
#     print(f"[+] OCR Success. Extracted {len(text)} chars.")
#     return text

# def extract_items_from_ocr(ocr_text: str):
#     if not ocr_text: return []
#     print("[*] Parsing with Gemini (Text)...")
#     # model = genai.GenerativeModel('gemini-2.5-flash')
#     prompt = f"""
#     Extract FOOD items from this receipt text.
#     Ignore non-food.
#     OCR TEXT:
#     {ocr_text}
#     """
#     try:
#         resp = client.models.generate_content(model="gemini-2.5-flash", contents = prompt, 
#                                                config={
#                                                         'response_mime_type': 'application/json',
#                                                         'response_schema': list[schema.Receipt],
#                                                         }
#         )
#         # data = extract_json_from_text(resp.text)
#         # items = data.get("items", []) if data else []
#         # print(f"[+] Extracted {len(items)} items.")
#         return(resp.text)
#     except Exception as e:
#         print(f"[-] Error: {e}")
#         return []


# def gemini_vision_identify_count(image_path: str):
#     """Identifies and counts grocery items in a photo."""
#     print(f"[*] AI Eyes: Analyzing {image_path}...")
#     if not os.path.exists(image_path):
#         print("File not found.")
#         return []
    
    
#     img = PIL.Image.open(image_path)
    
#     prompt = """
#     Identify all FOOD items in this photo.
#     Count them.
#     """
#     try:
#         resp = client.models.generate_content(model="gemini-2.5-flash", contents = [img, prompt], 
#                                                config={
#                                                         'response_mime_type': 'application/json',
#                                                         'response_schema': list[schema.ImageExtract],
#                                                         }
#     )
        
#         # data = extract_json_from_text(resp.text)
#         # items = data.get("items", []) if data else []
#         # print(f"[+] Vision found {len(items)} distinct item types.")
#         return(resp.text)
#     except Exception as e:
#         print(f"[-] Vision Error: {e}")
#         return []


# print(extract_items_from_ocr(run_vision_ocr('D:\\KitaHack 2026\\Backend\\camera_func\\test_3.png')))

# print(gemini_vision_identify_count('D:\KitaHack 2026\Backend\camera_func\grocery.png'))