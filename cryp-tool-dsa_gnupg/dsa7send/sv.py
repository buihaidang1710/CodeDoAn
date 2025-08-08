import socket
from cryptography.hazmat.primitives.asymmetric import dsa
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.serialization import Encoding, PublicFormat


private_key = dsa.generate_private_key(key_size=2048)
public_key = private_key.public_key()


with open("public_key.pem", "wb") as pub_file:
    pub_file.write(public_key.public_bytes(Encoding.PEM, PublicFormat.SubjectPublicKeyInfo))


file_path = input("Nhap duong dan tep can ky : ")
file_name = file_path.split("/")[-1]  


user_signature = input("Nhap thong diep di kem : ").encode()


def create_signature(file_path, private_key, user_signature):
    with open(file_path, 'rb') as file:
        file_data = file.read()
    combined_data = file_data + user_signature
    signature = private_key.sign(combined_data, hashes.SHA256())
    return signature


signature = create_signature(file_path, private_key, user_signature)
print("Chu ky da duoc tao")


server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind(('0.0.0.0', 12345))
server_socket.listen(20)
print("Server dang lang nghe...")

conn, addr = server_socket.accept()
print(f"Ket noi tu : {addr}")


conn.sendall(file_name.encode() + b"\n---FILENAME---\n")


with open(file_path, 'rb') as file:
    conn.sendall(file.read() + b"\n---SIGNATURE---\n")
    print("Tep da duoc gui")


conn.sendall(signature + b"\n---PUBLIC KEY---\n")
print("Chu ky da duoc gui")


with open("public_key.pem", "rb") as pub_file:
    conn.sendall(pub_file.read())
    print("Khoa cong khai da duoc gui")


conn.close()
server_socket.close()
