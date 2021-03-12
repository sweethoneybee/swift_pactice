//
//  temp.cpp
//  Algorithm
//
//  Created by 정성훈 on 2021/03/12.
//

#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;

struct plusFunc {
    int operator()(const int&a, const int& b) {
        return a + b;
    }
};

void printVec(const vector<int>& vec) {
    for(auto item: vec) {
        cout << item << " ";
    }
    cout << endl;
}
int main() {
    cout << plusFunc()(1, 2) << endl;
    vector<int> vec = {1, 2, 3, 4, 5};
    
    printVec(vec);
    
    sort(vec.begin(), vec.end(), [](const int& a, const int& b) -> bool {return a > b;});
    printVec(vec);
    return 0;
}
