/*
 *  SocketServer.cpp
 *  BatmanServer
 *
 *  Created by Jared Pochtar on 11/26/11.
 *  Copyright 2011 Devclub. All rights reserved.
 *
 */

#include "SocketServer.h"
#include <netinet/in.h>
#include <string>
#include <iostream>

void error_die(const char *sc) {
	perror(sc);
	exit(1);
}

#pragma mark Connection

Connection::Connection(int clientfd) {
	client = clientfd;
}

Connection::~Connection(){
	close(client);
}

std::string Connection::read_available(bool blocking) {
	char buffer[256];
	ssize_t len = recv(client, &buffer, sizeof(buffer), blocking ? 0 : MSG_DONTWAIT);
	
	//more stuff here
	if (len < 0) {
		return "";
	}
	
	std::string asString(buffer, len);
	if (len == sizeof(buffer)) {
		asString += read_available(false);
	}
	return asString;	
}

void Connection::send(const char *input) {
	::send(client, input, strlen(input), 0);
}


#pragma mark SocketServer

/* 
   MEGA BIG NOTE:
   Can only handle 5 queued connections max, sorta, doesn't handle them in parallel
*/

SocketServer::SocketServer(int _port) {
	port = _port;
	
	server_sock = 0;
	struct sockaddr_in name;
	
	server_sock = socket(PF_INET, SOCK_STREAM, 0);
	if (server_sock == -1) {
		error_die("socket");
	}
	memset(&name, 0, sizeof(name));
	name.sin_family = AF_INET;
	name.sin_addr.s_addr = htonl(INADDR_ANY);
	
#define WEIRDNESS
#ifndef WEIRDNESS
	name.sin_port = htons(port);
	if (bind(server_sock, (struct sockaddr *)&name, sizeof(name)) < 0)
		error_die("bind");
#else
	//WEIRDNESS -- was supposed to be a workaround for trying to bind on a used port
	//stopped binding on a used port.  No idea why, but totally cool with it
	port--;
	do {
		port++;
		name.sin_port = htons(port);
	} while (bind(server_sock, (struct sockaddr *)&name, sizeof(name)) < 0);
	//Above this is where the weirdness is
#endif
	
	if (port == 0) {
		socklen_t namelen = sizeof(name);
		if (getsockname(server_sock, (struct sockaddr *)&name, &namelen) == -1) {
			error_die("getsockname");
		}
	}
	if (listen(server_sock, 5) < 0) {
		error_die("listen");
	}
}

Connection SocketServer::acceptConnection() {
	int client_sock = accept(server_sock, NULL, NULL);
	if (client_sock == -1)
		error_die("accept");
	
	return Connection(client_sock);
}

SocketServer::~SocketServer(){
	close(server_sock);
}
