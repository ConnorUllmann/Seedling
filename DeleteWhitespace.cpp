#include <fstream>
#include <iostream>
#include <string>

using namespace std;

int main()
{
	string si, so;
	cout << "File name: ";
	cin >> si;
	cout << "Output file name; ";
	cin >> so;
	ifstream input;
	input.open(si.c_str());
	ofstream output;
 	output.open(so.c_str());
	
	while(input.good())
	{
		string s;
		input >> s;
		if(input.good())
		{
			int pos = 0;
		 	const string removables = " \t\n";
		 	
		 	pos = s.find_first_of(removables);
			while(s[pos] != string::npos)
			{
				s = s.erase(pos, 1);
				pos = s.find_first_of(removables, pos+1);
			}
			
			output << s;
		}
	}
	return 0;
}
