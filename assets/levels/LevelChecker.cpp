#include <windows.h>
#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
#include <io.h>
#include <vector>
#include <dirent.h>
using namespace std;

void loopFiles(string directory, WIN32_FIND_DATA FindData, string def, string value, vector<int> &values, vector<string> &names);
void readFile(string filePath, string value, vector<int> &values, vector<string> &names) ;
void sort(vector<int> a, vector<int> &b);
string removeChars(string s, string removeChars);
string ExePath();
string dirNamePrepare(string);

const string defFile = "region1";
const string suffix = ".oel";
const string valueDef = "tag";
const string followingValue = "=\"";
const string endingValue = "\"";
const string dir = ExePath();

int main()
{
	while(true)
	{
		string def = "";
		string value = "";
		vector<int> values;
		vector<string> names;

		cout << "File name: ";
		cin >> def;
		if(def == "-")
			def = defFile;
		def += suffix;
		cout << def << endl;
		cout << "Value name: ";
		cin >> value;
		if(value == "-")
			value = valueDef;
		cout << value << endl << endl;
		
	    WIN32_FIND_DATA FindData;
	    HANDLE hFind;
	    
	   	string s = dir.c_str();
	   	loopFiles(s, FindData, def, value, values, names);
	    
	    vector<int> sorted;
	    sort(values, sorted);
	   	for(int i = 0; i < min(values.size(), names.size()); i++)
	   	{
	   		cout << values[sorted[i]] << ": " << names[sorted[i]] << endl;
	   	}
	    
	    cout << endl;
    }
    return 0;
}

void loopFiles(string directory, WIN32_FIND_DATA FindData, string def, string value, vector<int> &values, vector<string> &names)
{	
	HANDLE hFind;
	hFind = FindFirstFile((directory + "*").c_str(), &FindData);
	do
    {
    	string s = FindData.cFileName;
    	int startFile = s.find_last_of("\\");
    	if(startFile == string::npos)
    	{
    		startFile = -1;
   		}
     	if(s.substr(startFile+1) == def)
        {
        	readFile(directory + s, value, values, names);
        	break;
        }
    } while (FindNextFile(hFind, &FindData));
}

void readFile(string filePath, string value, vector<int> &values, vector<string> &names) 
{
	ifstream inputFile;
	inputFile.open(filePath.c_str());
	if(inputFile.is_open())
    {
    	string s((istreambuf_iterator<char>(inputFile)), istreambuf_iterator<char>());
    	int i = 0;
    	while(i < s.length() && i != string::npos)
    	{
    		int extra = (value + followingValue).length();
        	int startPos = s.find(value + followingValue, i);
  	        int endPos = s.find(endingValue, startPos + extra);
  	        if(startPos == string::npos && i == 0)
        	{
        		cout << "No value of that kind found." << endl;
        		break;
       		}
       		if(startPos == string::npos || endPos == string::npos || i > endPos)
       		{
       			break;
   			}
       		startPos += extra;
        	values.push_back(atoi(s.substr(startPos, endPos - startPos).c_str()));
        	
        	int nStart = s.find_last_of("<", startPos);
        	if(nStart != string::npos)
        	{
        		int nEnd = s.find_first_of(" x", nStart);
	        	if(nEnd != string::npos)
	        	{
	        		names.push_back(s.substr(nStart, nEnd - nStart)+">");
	       		}
       		}
        	i = endPos;
    	}
        inputFile.close();
    }
    else
    {
        cout << "\nError opening file = " << filePath << endl;
        return;
    }
}

void sort(vector<int> a, vector<int> &b)
{
	for(int i = 0; i < a.size(); i++)
	{
		b.push_back(i);
	}
	for(int i = 0; i < a.size(); i++)
	{
		for(int j = 0; j < a.size(); j++)
		{
			if(a[i] < a[j])
			{
				int temp = a[i];
				a[i] = a[j];
				a[j] = temp;
				
				temp = b[i];
				b[i] = b[j];
				b[j] = temp;
			}
		}
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
