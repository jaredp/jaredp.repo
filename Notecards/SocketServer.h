/*
 *  SocketServer.h
 *  BatmanServer
 *
 *  Created by Jared Pochtar on 11/26/11.
 *  Copyright 2011 Devclub. All rights reserved.
 *
 */
 

#include <string>

class Connection {
	int client;
	
public:
	Connection(int clientfd);	
	~Connection();
	
	std::string read_available(bool blocking=true);
	void send(const char *input);
};

class SocketServer {
	int server_sock;
	int port;
	
public:
	SocketServer(int _port);
	Connection acceptConnection();
	~SocketServer();
	int getPort() {
		return port;
	}
};


// utils
void error_die(const char *sc);
std::string read_available(int fd, bool blocking=true);
