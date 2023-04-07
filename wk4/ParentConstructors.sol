// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=nPtEpw4olSk

// 2 ways to call parent constructors
// order or initialization
contract S {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }
}

contract T {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }
}

// static input for parent constructors
contract U is S("s"), T("t") {

}

// dynamic input for parent constructors
contract V is S, T {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {

    }
}

// combine static and dynamic input for parent constructors
contract VV is S("s"), T {
    constructor(string memory _text) T(_text) {
        
    }
}


// constructor 呼叫順序 S > T > V0
contract V0 is S, T {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {

    }
}

// constructor 呼叫順序 S > T > V1
contract V1 is S, T {
    constructor(string memory _name, string memory _text) T(_text) S(_name) {

    }
}

// constructor 呼叫順序 T > S > V2
contract V2 is T, S {
    constructor(string memory _name, string memory _text) S(_name) T(_text) {

    }
}

// constructor 呼叫順序 T > S > V3
contract V3 is T, S {
    constructor(string memory _name, string memory _text) T(_text) S(_name) {

    }
}
// 總結：呼叫的順序是依照 contract 繼承的順序，不是依照 constructor 內呼叫 parent constructor 的順序