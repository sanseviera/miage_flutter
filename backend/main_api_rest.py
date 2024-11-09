from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import base64
from io import BytesIO
from keras.models import load_model
from keras.preprocessing import image
import numpy as np
from PIL import Image
import tensorflow as tf
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import base64
from io import BytesIO
from keras.models import load_model
from keras.preprocessing import image
import numpy as np
from PIL import Image

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Vous pouvez restreindre cela à des origines spécifiques si nécessaire
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load the pre-trained Keras model (replace with your actual model path)
model = load_model('mon_modele.h5')

class ImageData(BaseModel):
    data: str  # This will now match the "data" field in the incoming JSON

@app.get("/")
def read_root():
    return {"Hello": "World"}

@app.post("/run")
def run_prediction(data: ImageData):
    try:
        # Decode the base64 image
        img_data = base64.b64decode(data.data)  # Decoding from the 'data' field
        img = Image.open(BytesIO(img_data))

        # Resize the image according to the model's expected input shape
        img = img.resize((80, 80))  # Adjust this to your model's input size
        img_array = image.img_to_array(img)  # Convert to numpy array
        img_array = img_array / 255.0  # Normalize the image (if needed by the model)
        img_array = np.expand_dims(img_array, axis=0)  # Add a batch dimension

        # Make predictions
        predictions = model.predict(img_array)

        # Debugging: print raw predictions
        print(f"Raw predictions: {predictions}")

        # Get the class index with the highest probability
        class_index = np.argmax(predictions[0])

        # Return the class index as JSON
        return {"class_index": int(class_index), "predictions": predictions.tolist()}

    except Exception as e:
        print(f"Error during prediction: {e}")
        raise HTTPException(status_code=500, detail="Error processing the image.")