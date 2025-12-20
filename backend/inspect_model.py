import pickle
import pandas as pd
import os
import joblib

model_path = 'backend/models/crop_recommendation_model.pkl'
output_file = 'backend/model_info.txt'

def inspect(obj, name="Model", f_out=None):
    f_out.write(f"\nInspecting {name}: {type(obj)}\n")
    if hasattr(obj, 'feature_names_in_'):
        f_out.write(f"Feature Names: {list(obj.feature_names_in_)}\n")
    elif hasattr(obj, 'n_features_in_'):
         f_out.write(f"Number of Features: {obj.n_features_in_}\n")
    elif hasattr(obj, 'classes_'):
        f_out.write(f"Classes: {list(obj.classes_)}\n")
    else:
        f_out.write("Could not determine details directly.\n")

with open(output_file, 'w', encoding='utf-8') as f_out:
    try:
        f_out.write("Trying pickle...\n")
        with open(model_path, 'rb') as f:
            model = pickle.load(f)
        inspect(model, "Model", f_out)
    except Exception as e:
        f_out.write(f"Pickle failed: {e}\n")
        try:
            f_out.write("Trying joblib...\n")
            model = joblib.load(model_path)
            inspect(model, "Model", f_out)
        except Exception as e2:
            f_out.write(f"Joblib failed: {e2}\n")

    # Also check encoders
    f_out.write("\n--- Encoders ---\n")
    for filename in os.listdir('backend/models'):
        if 'encoder' in filename:
            path = os.path.join('backend/models', filename)
            try:
                with open(path, 'rb') as f:
                    encoder = pickle.load(f)
                inspect(encoder, filename, f_out)
            except:
                 try:
                    encoder = joblib.load(path)
                    inspect(encoder, filename, f_out)
                 except Exception as e:
                     f_out.write(f"Failed to load {filename}: {e}\n")
