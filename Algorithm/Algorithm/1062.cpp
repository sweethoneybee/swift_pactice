#include <iostream>
#include <set>
#include <vector>
#include <string>
using namespace std;

int N, K;
vector<string> words;

void combination(const vector<char>& originalPool, set<char>& charPool, int startIndex, int& answer);
int canReadCount(set<char>& charPool);
vector<char> makeOriginalPool(const vector<string>& words);

int main(void)
{
    cin >> N;
    cin >> K;
    for(int i = 0; i < N; i++)
    {
        string input;
        cin >> input;
        words.push_back(input);
    }
    
    int answer = 0;
    if(K >= 5)
    {
        vector<char> originalPool = makeOriginalPool(words);
        if(originalPool.size() > K)
        {
            set<char> charPool = {'a', 'c', 'i', 'n', 't'};
            combination(originalPool, charPool, 5, answer);
        } else {
            answer = words.size();
        }
    }
    
    cout << answer;
    return 0;
}

void combination(const vector<char>& originalPool, set<char>& charPool, int startIndex, int& answer)
{
    if (charPool.size() >= K)
    {
        const int wordCount = canReadCount(charPool);
        if (wordCount > answer)
        {
            answer = wordCount;
        }
        return;
    }
    else
    {
        for(int i = startIndex, size = originalPool.size(); i < size; i++)
        {
            charPool.insert(originalPool[i]);
            combination(originalPool, charPool, i + 1, answer);
            charPool.erase(originalPool[i]);
        }
        return;
    }
    
}

int canReadCount(set<char>& charPool)
{
    int count = 0;
    for(auto iter = words.begin(), end = words.end(); iter != end; iter++)
    {
        const string& word = (*iter);
        bool canRead = true;
        for(int i = 4, len = word.length() - 4; i < len; i++)
        {
            if(charPool.find(word[i]) == charPool.end())
            {
                canRead = false;
                break;
            }
        }
        if(canRead)
        {
            count += 1;
        }
    }
    return count;
}

vector<char> makeOriginalPool(const vector<string>& words)
{
    vector<char> originalPool = {'a', 'c', 'i', 'n', 't'};
    
    set<char> pool = {'a', 'c', 'i', 'n', 't'};
    for(auto iter = words.begin(), end = words.end(); iter != end; iter++)
    {
        const string& word = (*iter);
        for(int i = 0, len = word.length(); i < len; i++)
        {
            if(pool.find(word[i]) == pool.end())
            {
                pool.insert(word[i]);
                originalPool.push_back(word[i]);
            }
        }
    }
    return originalPool;
}
