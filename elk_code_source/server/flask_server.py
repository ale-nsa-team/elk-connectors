# rec.py
from flask import Flask, request
import os

# Initialize Flask application
app = Flask(__name__)

# Folder to save uploaded files
UPLOAD_FOLDER = '/tmp/uploads'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)

@app.route('/upload', methods=['POST'])
def upload_file():
    """
    Endpoint to receive uploaded files via HTTP POST.
    Each uploaded file is saved in the UPLOAD_FOLDER.
    """
    print("Received file fields:", list(request.files.keys()))

    if not request.files:
        return 'No files found in request', 400

    for field_name in request.files:
        file = request.files[field_name]
        if file.filename == '':
            continue  # Skip empty filenames
        filepath = os.path.join(UPLOAD_FOLDER, file.filename)
        file.save(filepath)
        print(f"Saved file from field '{field_name}' as '{filepath}'")

    return 'Files uploaded successfully\n', 200

if __name__ == '__main__':
    # Run Flask server on 0.0.0.0:31175
    app.run(host='0.0.0.0', port=31175)

