# 🍎 PantryMind: Your AI-Powered Kitchen Command Center

**PantryMind** is an intelligent pantry management ecosystem designed to eliminate food waste, optimize grocery spending, and take the guesswork out of meal prep. By leveraging AI to track inventory and analyze local pricing, PantryMind ensures you always have a plan—and the best deal—for your next meal.

Check out our frontend prototype on Figma: https://www.figma.com/proto/iffKfNNLncXiIQHG669SFr/KitaHack-2026-Masterplan?node-id=1-2&p=f&t=Co80kdWYfv8ltvTM-1&scaling=scale-down&content-scaling=fixed&page-id=0%3A1&starting-point-node-id=1%3A2 
---

## 🚀 Key Features

### 1. AI-Driven Meal Planning
* **Smart Suggestions:** Uses **Gemini LLM** to generate personalized recipes based on what you *actually* have in your pantry.
* **Gap Analysis:** Automatically identifies missing ingredients and adds them to a digital shopping list.
* **Preference Matching:** Tailors results to dietary restrictions, caloric goals, or specific cuisines.

### 2. Intelligent Inventory Tracking
* **OCR Receipt Scanning:** Powered by **Google Vision AI** to instantly log items, quantities, and prices from receipts or product photos.
* **Visual Recognition:** Identify loose produce or pantry staples, making manual entry a thing of the past.
* **Database Management:** All inventory is securely managed and queried via **PostgreSQL**.

### 3. Malaysian Price Optimization (PriceCatcher)
* **Official Data Integration:** Uses data from the **PriceCatcher** platform (Ministry of Domestic Trade and Costs of Living, Malaysia) to track goods across every market in Malaysia.
* **Location-Based Savings:** Integrated with **Google Maps** to find the cheapest items at the stores closest to you.


---

## 🏗️ System Architecture

PantryMind follows a modular microservices-inspired architecture to ensure the AI processing doesn't bottleneck the user experience.



### High-Level Data Flow
1.  **Ingestion Layer:** The mobile/web frontend sends receipt images or voice prompts to the backend.
2.  **Processing Layer:** * **Vision Engine:** Extracts text from receipts using OCR and structures it into JSON.
    * **LLM Engine:** Processes natural language for meal planning and maps extracted items to a standard database (e.g., "1 gal milk" → "Dairy/Milk").
3.  **Optimization Layer:** Queries local grocery APIs or cached pricing data to find the best shopping route.
4.  **Storage Layer:** Updates the user's persistent inventory in the database.

### Recipe Generation Logic
The meal planning engine uses a "Weighted Inventory" approach. The priority score for recipe suggestions is calculated as:

$$Score = (I_{stock} \times W_{expiry}) + P_{user}$$

* $I_{stock}$: Items currently in the pantry.
* $W_{expiry}$: Weight multiplier for items nearing expiration.
* $P_{user}$: User's specific cravings or dietary filters.

---

## 📸 How It Works: OCR & Extraction

The core of the "Mind" in PantryMind is the ability to turn a messy receipt into clean data.

1.  **Image Pre-processing:** We use Grayscale and Thresholding to make text pop and remove background noise.
2.  **Text Detection:** Identifying "blocks" of text like Item Names, Quantities, and Prices.
3.  **Regex & AI Cleaning:** Cleaning up typos (e.g., "M1lk" becomes "Milk") and categorizing the item using a Large Language Model.


---

## 🛠️ Technical Stack

| Component | Technology |
| :--- | :--- |
| **Frontend** | Flutter, JavaScript |
| **Backend** | Python (FastAPI) |
| **AI/ML** | Gemini 3.1 Pro & Google OCR Model |
| **Database** | PostgreSQL |
| **DevOps** | GitHub Actions |

---

## 🚦 Getting Started

### Prerequisites
* Python 3.9+
* Node.js & npm (for frontend)
* API Keys for: OpenAI, Google Cloud Vision (or similar)

### Installation
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/yourusername/PantryMind.git](https://github.com/yourusername/PantryMind.git)
   cd PantryMind

2. **Setup the virtual environment**
  python -m venv venv
  source venv/bin/activate  # On Windows: venv\Scripts\activate
  pip install -r requirements.txt

3. **Configure Environment Variables**
   Change the .env file by editing the variable to access Google Gemini 
   KEY=your_key_here
