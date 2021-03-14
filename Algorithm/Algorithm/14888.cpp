//
//  temp.cpp
//  Algorithm
//
//  Created by 정성훈 on 2021/03/12.
//

#include <iostream>
#include <vector>

using namespace std;

int N = 0;
int maxAnswer = -1000000001;
int minAnswer = 1000000001;

void permutation(const vector<int>& operands, vector<int>& operators, int operateCount, int result) {
    if (operateCount >= N - 1) {
        if (result > maxAnswer) {
            maxAnswer = result;
        }
        if (result < minAnswer) {
            minAnswer = result;
        }
    } else {
        for(int i = 0, size = operators.size(); i < size; i++) {
            if (operators[i] == 0) {
                continue;
            }
            
            operateCount += 1;
            operators[i] -= 1;
            switch (i) {
                case 0:
                    permutation(operands, operators, operateCount, result + operands[operateCount]);
                    break;
                case 1:
                    permutation(operands, operators, operateCount, result - operands[operateCount]);
                    break;
                case 2:
                    permutation(operands, operators, operateCount, result * operands[operateCount]);
                    break;
                case 3:
                    permutation(operands, operators, operateCount, result / operands[operateCount]);
                    break;
                default:
                    break;
            }
            operators[i] += 1;
            operateCount -= 1;
        }
    }
}

int main(void) {
    vector<int> operands;
    vector<int> operators;
    
    cin >> N;
    for(int i = 0; i < N; i++) {
        int operand = 0;
        cin >> operand;
        operands.push_back(operand);
    }
    for(int i = 0; i < 4; i++) {
        int _operator = 0;
        cin >> _operator;
        operators.push_back(_operator);
    }
    
    permutation(operands, operators, 0, operands.front());
    
    cout << maxAnswer << endl;
    cout << minAnswer << endl;
    
    return 0;
}
