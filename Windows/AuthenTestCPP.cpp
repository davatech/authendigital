// AuthenTestCPP.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "AuthenDigital.h"
#include <iostream>
#include <sstream>
#include <string>
#include <cstdio>
#include <stdlib.h>
#include <stdio.h>
#include <Windows.h>
#include <dos.h>
#include <conio.h>
#include <fstream>
#include <vector>
#include <algorithm>


// Colors
#define BLACK 0
#define BLUE 1
#define GREEN 2
#define CYAN 3
#define RED 4
#define MAGENTA 5
#define BROWN 6
#define LIGHTGRAY 7
#define DARKGRAY 8
#define LIGHTBLUE 9
#define LIGHTGREEN 10
#define LIGHTCYAN 11
#define LIGHTRED 12
#define LIGHTMAGENTA 13
#define YELLOW 14
#define WHITE 15

//#define _TEST

const char * prompt();
void putTopMenu();
void authenResult(int vaultCode);
int jump(const char *);
std::string usertoken, servicetoken, session;


std::string getStr(wchar_t* value) {
	std::wstring ws(value);
	std::string str = std::string(ws.begin(), ws.end());
	return str;
}

// Console colors
void SetColor(int ForgC) {
	WORD wColor;
	HANDLE hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
	CONSOLE_SCREEN_BUFFER_INFO csbi;
	if (GetConsoleScreenBufferInfo(hStdOut, &csbi)) {
		wColor = (csbi.wAttributes & 0xF0) + (ForgC & 0x0F);
		SetConsoleTextAttribute(hStdOut, wColor);
	}
	return;
	// 0-Black, 1-Blue, 2-Green, 3-Cyan, 4-Red, 5-Magenta, 6-Brown, 7-Light Gray, 8-Dark Gray, 
	// 9-Light Blue, 10-Light Green, 11-Light Cyan, 12-Ligh Red, 13-Light Magenta, 14-Yellow, 15-White
}


// Message method
static void message(std::string m, int cc) {
#ifndef _TEST
	system("cls");
#endif // !_TEST
	SetColor(cc);
	puts(m.c_str());
}



//===============================================================================
//							    	CHANGE SESSION
//===============================================================================
static void changeSession() {

	// Get session
	if (session.length() == 40) {
		printf("Current token: ");
		SetColor(GREEN);
		printf(session.c_str());
		SetColor(YELLOW);
		puts("\nPress <1> to enter a new one, <R> to remove or <Q> to return");
	} else {
		puts("Press <1> to enter a new one or <Q> to return");
	}
	// Check choice
	char ch = _getch();
	const char* c = new char(ch);
	char code = c[0];
	printf("%c\n", code);
	if (ch == 'Q' || ch == 'q') { system("cls"); return; }
	if (ch == 'R' || ch == 'r') { session = ""; message("Session removed.", YELLOW); return; }
	if (ch != '1') { message("Invalid choice.", LIGHTRED); return; }
	// Get new userkey
	printf("Enter the new token: ");
	SetColor(GREEN);
	std::string resp;
	std::getline(std::cin, resp);
	// Check session
	if (resp.length() != 40) { message("Invalid token. Must have 40 digits!", LIGHTRED); return; } // We know it's 40 digits, right ?
	// Set new session
	AuthenDigital::setAuthenticationToken((char*)resp.c_str()); // SETUSERKEY COMMAND
	session = resp;

	// Display message
	message( "Authentication Token : " + resp + "(" + std::to_string(AuthenDigital::lastResult()) + ")", YELLOW);
}


//===============================================================================
//							    AUTHENTICATE
//===============================================================================
static void authenticate() {

	// Check user
	if (session.empty()) { message("Missing authentication token. Assign it first.", LIGHTRED); return; }
	std::cout << "\nAuthenticating..";
	// Set color
	SetColor(DARKGRAY);

	int result;
	result = AuthenDigital::authenticate(); // OPEN COMMAND
	std::cout << ".";
	if (result != 0) { message("Device Authentication Failed!", LIGHTRED);; return; }
	std::cout << ".";

	message("Device Authentication Success!", YELLOW);

}


//===============================================================================
//								ACTIVATE
//===============================================================================
static void activate() {
	// Get PC Name
	printf("\nEnter this PC name: " );
	SetColor(GREEN);
	std::string resp;
	std::getline(std::cin, resp);
	if (resp.length() < 3) { message(" Invalid name!", LIGHTRED); return; }
	std::cout << "\nActivating..";
	
	// SET DEVICE NAME COMMAND
	AuthenDigital::setDeviceName((char*)resp.c_str());
	// Set color
	SetColor(DARKGRAY);

	// ACTIVATE
	int result;
	result = AuthenDigital::activate();
	if (result != 0) { authenResult(result); return; }
	std::cout << ".";

	message("Authen Digital activated and this PC registered.", YELLOW);
}


//===============================================================================
//								INSERT
//===============================================================================
static void insert() {
	// Get PC Name
	printf("\nEnter this PC name: ");
	SetColor(GREEN);
	std::string resp;
	std::getline(std::cin, resp);
	if (resp.length() < 3) { message(" Invalid name! Need at least 3 characteres.", LIGHTRED); return; }
	std::cout << "\nConnecting..";
	// SET DEVICE NAME
	AuthenDigital::setDeviceName((char*)resp.c_str());
	// Set color
	SetColor(DARKGRAY);

	// INSERT
	int result;
	result = AuthenDigital::insert();
	authenResult(result);
	if (result != 0) { return; }
	std::cout << ".";

	message("This PC are now registered.", YELLOW);
}


void(*funcs[])() = { changeSession, activate, authenticate, insert, nullptr };

int main() {

	//system("cls");
	//loadData();
	while (jump(prompt()));
	SetColor(WHITE);
	puts("\nBye.");
	return 0;
}

void putTopMenu() {
	  puts("*********************************************************");
	printf(" Authen Digital C++ DEMO vr 1.0  /  AD Library vr %s\n", getStr(AuthenDigital::libVersion()).c_str());
	  puts("*********************************************************");
}

const char * prompt() {
	SetColor(LIGHTGREEN);
	putTopMenu();
	SetColor(DARKGRAY);
	puts("*** Setup");
	SetColor(WHITE);
	printf(" 1. Authentication Token [%s]\n", (session.length() == 40) ? "assigned" : "none");
	SetColor(DARKGRAY);
	puts(  "*** Commands");
	SetColor(WHITE);
	puts(" 2. Activate (enable Authen Digital)");
	puts(" 3. Authenticate");
	puts(" 4. Insert (this PC)");

	SetColor(DARKGRAY);

	SetColor(WHITE);
	puts(" Q. Quit");
	SetColor(YELLOW);
	printf(">> ");

	fflush(stdout);
	char ch = _getch();
	const char *response = new char(ch);
	return response;
}

int jump(const char * rs) {
	char code = rs[0];
	printf("%c\n", code);
	if (code == 'q' || code == 'Q') return 0;

	// count the length of the funcs array
	int func_length = 0;
	while (funcs[func_length] != NULL) func_length++;

	int i = -1;

	if (code == 'c' || code == 'C') {
		i = 11;
	}
	else {
		i = (int)code - '0';   // convert ASCII numeral to int
	}

	if (i == 0) { i = 10; }
	i--;        // list is zero-based
	if (i < 0 || i >= func_length) {
		message("Invalid choice.", LIGHTRED);
		return 1;
	}
	else {
		funcs[i]();
		return 1;
	}
}



// Vault return codes
static void authenResult(int errorCode) {
	switch (errorCode) {
		// Vault results
	case 0:  message("result 0: Good Result ", GREEN); break;
	case 1:  message("result 1: Internal Error ", LIGHTRED); break;
	case 2:  message("result 2: Device name already exists", LIGHTRED); break;
	case 3:  message("result 3: Device already registered", LIGHTRED); break;
	case 4:  message("result 4: User not enabled or not found ", LIGHTRED); break;
	case 5:  message("result 5: Device not enabled or not found", LIGHTRED); break;
	case 6:  message("result 6: Device limit reached ", LIGHTRED); break;
	case 7:  message("result 7: Device error", LIGHTRED); break;
	case 9:  message("result 9: IP Rejected", LIGHTRED); break;
	case 10:  message("result 10: Good Result Open", LIGHTRED); break;
	case -9: message("result -9: Invalid user", LIGHTRED); break;
	case -8: message("result -8: Invalid license", LIGHTRED); break;
	case -7: message("result -7: Invalid developer ", LIGHTRED); break;
	case -6: message("result -6: Invalid user token ", LIGHTRED); break;
	case -5: message("result -5: Session not found ", LIGHTRED); break;
	case -4: message("result -4: Invalid credential ", LIGHTRED); break;
	case -3: message("result -3: Session error ", LIGHTRED); break;
	case -2: message("result -2: Invalid rights ", LIGHTRED); break;
	case -1: message("result -1: Invalid operation ", LIGHTRED); break;
		// Connection results
	case -12: message("Error -12: Could not create connection", LIGHTRED); break;
	case -11: message("Error -11: Could not connect", LIGHTRED); break;
	default: message("Authen error result: " + std::to_string(errorCode), LIGHTRED); break;
	}
}

