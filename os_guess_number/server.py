import select                                                 # inbuilt modules imported for making sockets 
import socket
import random

port = 5000                                                    # port number
host = socket.gethostname()                                    # name of host
server =  socket.socket(socket.AF_INET, socket.SOCK_STREAM)     # initiating TCP connection
server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
server.bind(('',port))                                          # host and port no. are binded
server.listen(1)                                                # server is listening for clients
server.setblocking(0)                                           # for non-blocking I/O and multiple clients

rlist = [server]                                                # readable active connection list
clients = {}                                                    # client's list containing addresses

number = random.randint(1,100)

over = False
while True:
    try:
        in_list, out, excpt = select.select(rlist, [], [])          # those active clients are put in in_list and 
    except select.error, e:                                     # their particular addresses are pushed into client's list as rlist is appended
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
            	print message,sock,clients[sock]                       # here the clients guess a number trying to match the server's guess, wherein the match is guided by the server asking the cient to guess larger or smaller 
                #handle_request(message, sock, clients[sock])
                if int(message) > number:
                	sock.send("guess small")
                elif int(message) < number:
                	sock.send("guess large")
                else:
                	sock.send("U won")		 # once the guess is matched an individual is declared as the winner and the rest of the clients are sent a message as that they lose 
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

 
