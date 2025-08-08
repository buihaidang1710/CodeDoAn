import socket
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import serialization, hashes


HOST = '0.0.0.0' 
PORT = 65432       

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind((HOST, PORT))
server_socket.listen(20)
print(f"Server dang cho ket noi........")

try:
    
    conn, addr = server_socket.accept()
    print(f"Ket noi tu {addr}")

    public_key_pem = conn.recv(2048)
    client_public_key = serialization.load_pem_public_key(public_key_pem)


    data = conn.recv(1024).decode('utf-8')
    print("Thong diep tu client :", data)

    
    confirmation_message = input("Thong diep xac nhan cho client: ")

    
    encrypted_message = client_public_key.encrypt(
        confirmation_message.encode('utf-8'),
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )

    
    conn.sendall(encrypted_message)
    print("Da gui xac nhan")
    conn.close()

except KeyboardInterrupt:
    print("\nServer stop")
finally:
    server_socket.close()
