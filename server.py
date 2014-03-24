import select
import socket
import random

port = 5000
host = socket.gethostname()
server =  socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind(('',port))
server.listen(1)
server.setblocking(0)

rlist = [server]
clients = {}

number = random.randint(1,100)

over = False
while True:
    try:
        in_list, out, excpt = select.select(rlist, [], [])
    except select.error, e:
        break
    except socket.error, e:
        break

    for sock in in_list:
        if over:
        	sock.send("Game Complete-U Lost to  Player %s " % clients[sock][1:] )
        	rlist.remove(sock)
        	del clients[sock]
        	sock.close()
        elif sock == server:
            client_sock, address = sock.accept()
            client_sock.setblocking(0)
            rlist.append(client_sock)
            clients[client_sock] = address
        else:
            message = sock.recv(1024)
            if len(message):
            	print message,sock,clients[sock]
                #handle_request(message, sock, clients[sock])
                if int(message) > 50:
                	sock.send("guess small")
                elif int(message) < 50:
                	sock.send("guess large")
                else:
                	sock.send("U won")		
                	rlist.remove(sock)
                	del clients[sock]
                	sock.close()
                	over = True
                	break
            else:
                del clients[sock]
                rlist.remove(sock)
                sock.close()
#--
server.close()

 
