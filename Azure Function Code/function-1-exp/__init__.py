import logging
import os
import pickle
from sklearn import linear_model
import pandas as pd
import numpy as np
import azure.functions as func
import warnings
warnings.filterwarnings("ignore")

modelFilePath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'bundled_model.pkl')

try:
    with open(modelFilePath, 'rb') as f:
        lr_clf, X = pickle.load(f)
except Exception as e:
    print(f"Error: Failed to load the pickle file. Details: {e}")



def predict_price(location,sqft,bath,bhk):
    loc_index = np.where(X.columns==location)[0][0]
    x = np.zeros(len(X.columns))

    x[0] = sqft
    x[1] = bath
    x[2] = bhk
    if loc_index >= 0:
        x[loc_index] = 1
        
    return (lr_clf.predict([x])[0])


def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    location = req.params.get('location')
    total_sqft = req.params.get('total_sqft')
    bathrooms = req.params.get('bathrooms')
    bhk = req.params.get('bhk')

    try:
        predicted_price = predict_price(location, total_sqft, bathrooms, bhk)
        predicted_price = round(predicted_price, 2)
        return func.HttpResponse(f"{str(predicted_price)}", status_code=200)
    
    except Exception as e:
        logging.error(str(e))
        return func.HttpResponse(f"Something is Wrong {str(e)}", status_code=400)