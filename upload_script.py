import argparse
import os
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

def upload_file(file_path, folder_id, service_account_file):
    """
    Uploads a file to Google Drive using a service account for authentication.
    Deletes an older file with the same name in the specified folder before uploading.

    Parameters:
    - file_path: Path to the file to be uploaded.
    - folder_id: Google Drive folder ID where the file will be uploaded.
    - service_account_file: Path to the service account credentials file.
    """
    # Define the required scopes
    SCOPES = ['https://www.googleapis.com/auth/drive']

    # Load the service account credentials and create a Drive service
    creds = service_account.Credentials.from_service_account_file(
        service_account_file, scopes=SCOPES)
    service = build('drive', 'v3', credentials=creds)

    # Search for an existing file with the same name in the specified folder
    file_name = os.path.basename(file_path)
    query = f"name = '{file_name}' and '{folder_id}' in parents and trashed = false"
    response = service.files().list(q=query, spaces='drive', fields='files(id, name)').execute()
    files = response.get('files', [])

    # If an existing file is found, delete it
    for file in files:
        service.files().delete(fileId=file.get('id')).execute()
        print(f"Deleted old file with ID: {file.get('id')}")

    # Define file metadata, including the name and the folder ID
    file_metadata = {
        'name': file_name,
        'parents': [folder_id]
    }

    # Create a media file upload object and execute the upload
    media = MediaFileUpload(file_path, resumable=True)
    file = service.files().create(body=file_metadata, media_body=media, fields='id').execute()

    # Print the uploaded file ID
    print(f"File ID: {file.get('id')}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Uploads a file to Google Drive using a service account.')
    parser.add_argument('--service-account-file', type=str, required=True, help='Path to service account credentials file.')
    parser.add_argument('--file-path', type=str, required=True, help='Path to the file to upload.')
    parser.add_argument('--folder-id', type=str, required=True, help='Google Drive folder ID to upload the file to.')

    args = parser.parse_args()

    upload_file(args.file_path, args.folder_id, args.service_account_file)
