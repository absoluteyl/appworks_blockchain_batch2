// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ref: https://www.youtube.com/watch?v=lqRYnIejWMk

/* 
calling parent functions
   - direct
   - super

     E
    / \ 
   F   G
    \ /
     H
*/

contract E {
  event Log(string message);

  function foo() public virtual {
    emit Log("E.foo");
  }

  function bar() public virtual {
    emit Log("E.bar");
  }
}


contract F is E{
  // use E's name to call function in E
  function foo() public virtual override {
    emit Log("F.foo");
    E.foo();
  }

  // use "super" to call function in E
  function bar() public virtual override {
    emit Log("F.bar");
    super.bar();
  }
}

contract G is E{
  // use E's name to call function in E
  function foo() public virtual override {
    emit Log("G.foo");
    E.foo();
  }

  // use "super" to call function in E
  function bar() public virtual override {
    emit Log("G.bar");
    super.bar();
  }
}

contract H is F, G{
  // use F's name to call function in F
  function foo() public override(F, G) {
    emit Log("H.foo");
    F.foo();
  }
  // 執行結果 H.foo > F.foo > E.foo

  // super will call all parents, so functions in both F and G will be called
  function bar() public override(G, F) {
    emit Log("H.bar");
    super.bar();
  }
  // 繼承順序是 F, G 時執行結果 H.bar > G.bar > F.bar > E.bar
  // 如果繼承順序是 G, F 時執行結果 H.bar > F.bar > G.bar > E.bar
  // (這邊跟 parent constructors 一樣，跟 function 中 override 順序無關，只跟繼承順序有關）
}
