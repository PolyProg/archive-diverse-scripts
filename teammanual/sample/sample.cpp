#include <iostream>
using namespace std;
int main(int argc, char** argv) {
  std::ios::sync_with_stdio(false);
  int num_testcases, a, b;
  cin>>num_testcases;
  for(int i=0;i<num_testcases;++i) {
    cin>>a>>b;
    cout<<a+b<<" "<<a-b<<endl;
  }
  return 0;
} 
