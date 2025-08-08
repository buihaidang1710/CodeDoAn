import socket
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.serialization import load_pem_public_key

import os

save_directory = "received_files"
os.makedirs(save_directory, exist_ok=True) 

def save_to_file(filename, data):
    file_path = os.path.join(save_directory, filename)
    with open(file_path, 'wb') as file:
        file.write(data)
    return file_path
def delete_files_in_directory(directory):
    try:
        for filename in os.listdir(directory):
            file_path = os.path.join(directory, filename)
            if os.path.isfile(file_path):
                os.remove(file_path)
    except Exception as e:
        print(f"Loi xoa tep: {e}")
        
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_address = ('', 12345)
client_socket.connect(server_address)
print("Da ket noi toi server")

received_data = b""
while True:
    chunk = client_socket.recv(4096) 
    if not chunk:
        break
    received_data += chunk

client_socket.close()
print("Du lieu da duoc nhan tu server.")

parts = received_data.split(b"\n---FILENAME---\n")
if len(parts) != 2:
    print("Loi khong tim thay tep")
    exit()

file_name = parts[0].decode()  
file_and_signature = parts[1].split(b"\n---SIGNATURE---\n")
if len(file_and_signature) != 2:
    print("Loi khong tim thay chu ky")
    exit()

file_data = file_and_signature[0]
signature_and_key = file_and_signature[1].split(b"\n---PUBLIC KEY---\n")
if len(signature_and_key) != 2:
    print("Loi khong tim thay khoa")
    exit()

signature = signature_and_key[0]
public_key_data = signature_and_key[1]

file_path = save_to_file(file_name, file_data)
save_to_file("signature.sig", signature)
public_key_path = save_to_file("public_key.pem", public_key_data)

user_signature = input("Nhap thong diep di kem de xac thuc: ").encode()

try:
    public_key = load_pem_public_key(public_key_data)
except Exception as e:
    print("Loi khi tai khoa cong khai:", e)
    exit()


try:
    combined_data = file_data + user_signature
    public_key.verify(signature, combined_data, hashes.SHA256())
    print("Xac thuc chu ky thanh cong")
except Exception as e:
    print("Xac thuc chu ky that bai ! Loi:", e)
    delete_files_in_directory(save_directory)
