#include <windows.h>
#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
#include <io.h>
#include <vector>
#include <dirent.h>
using namespace std;

void loopFiles(string directory, WIN32_FIND_DATA FindData);
void getFileLines(string directory);
int numDigits(int n);
string ExePath();
string dirNamePrepare(string);
string removeChars(string s, string removeChars);

const string defFile = "Game.as";
const string arrayDef = "levels";
const string followingArray = ":Array=newArray(";
const string endingArray = ")";
const string dir = ExePath();

string def = "";
string array = "";
vector<string> names;

int main()
{
	cout << "File name: ";
	cin >> def;
	if(def == "-")
		def = defFile;
	cout << dir + def << endl;
	cout << "Array name: ";
	cin >> array;
	if(array == "-")
		array = arrayDef;
	cout << array << endl << endl;
	
    WIN32_FIND_DATA FindData;
    HANDLE hFind;
    
   	string s = dir.c_str();
   	loopFiles(s, FindData);
   	
   	ofstream outputFile;
    outputFile.open("World.txt");
   	for(int i = 0; i < names.size(); i++)
   	{
   		cout << i << ": " << names[i] << endl;
   		outputFile << i << ": " << names[i] << endl;
   	}
   	outputFile.close();
    
    cout << endl;
    //system("pause");
    return 0;
}

void loopFiles(string directory, WIN32_FIND_DATA FindData)
{	
	HANDLE hFind;
	hFind = FindFirstFile((directory + "*").c_str(), &FindData);
	do
    {
    	string s = FindData.cFileName;
    	if(s == def)
        {
        	getFileLines(directory + s);
        	break;
        }
    } while (FindNextFile(hFind, &FindData));
}

//Returns the number of lines in a file.
void getFileLines(string filePath) 
{
	ifstream inputFile;
	inputFile.open(filePath.c_str());
	if(inputFile.is_open())
    {
    	string s((istreambuf_iterator<char>(inputFile)), istreambuf_iterator<char>());
    	s = removeChars(s, "\n\t ");
        int startPos = s.find(array + followingArray) + (array + followingArray).length();
  	    int endPos = s.find(endingArray, startPos);
  	    
  	    int i = startPos-1;
  	    int c = startPos;
  	    while(c != string::npos && c < endPos)
  	    {
  	    	c = min((int)s.find_first_of(',', i+1), endPos);
  	    	string sTemp = s.substr(i+1, c - i);
  	    	sTemp = removeChars(sTemp, ",);");
  		    names.push_back(sTemp);
  	    	i = c;
  	    }
        inputFile.close();
    }
    else
    {
        cout << "\nError opening file = " << filePath << endl;
        return;
    }
}

string removeChars(string s, string removeChars)
{
	int removeCharPos = s.find_first_of(removeChars);
    while(removeCharPos != string::npos)
    {
  	   	s.erase(removeCharPos,1);
  	   	removeCharPos = s.find_first_of(removeChars);
	}
	return s;
}
 
//Found online via http://stackoverflow.com/questions/875249/how-to-get-current-directory
string ExePath() 
{
    char buffer[MAX_PATH];
    GetModuleFileName( NULL, buffer, MAX_PATH );
    string::size_type pos = string( buffer ).find_last_of( "\\/" );
    return dirNamePrepare(string( buffer ).substr( 0, pos) + "\\");
}

string dirNamePrepare(string s)
{
	size_t temp = s.find_first_of("\\");
	while(temp != string::npos) 
	{
		s.insert(temp, "\\");
		temp = s.find_first_of("\\", temp+2);
	}
	return s;
}
