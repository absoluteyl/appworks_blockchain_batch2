// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 製作一款寶可夢遊戲
// 一個寶可夢需要有名稱，攻擊與防禦這三種屬性
// 根據地址，可以查詢到該玩家所擁有的寶可夢
// 一個玩家可以有多個寶可夢
// 需要有一個 create 的方法來創造出寶可夢
// （optional) 可付費 0.1 ETH 來增加該玩家所擁有的特定寶可夢的攻擊或是防禦
contract PokemonGame {
    struct Pokemon {
        string name;
        uint attack;
        uint defense;
    }
    mapping (address => Pokemon[]) ownerToPokemons;

    // Create Pokemon of Msg Sender
    function create(string calldata _name) external {
        // Generate random attack, defense points.
        uint _attack = uint(keccak256(abi.encodePacked(_name))) % 1000 * 5;
        uint _defense = uint(keccak256(abi.encodePacked(_name))) % 100 * 60;

        // Init the pokemon
        Pokemon memory _pokemon = Pokemon(_name, _attack, _defense);

        // Add it to sender's collection.
        ownerToPokemons[msg.sender].push(_pokemon);
    }

    // List all Pokemons of Msg Sender
    function list() external view returns (Pokemon[] memory _pokemons) {
        return ownerToPokemons[msg.sender];
    }

    // Add Attack points of selected pokemon of Msg Sender
    function addAttack(uint pokemonIdx) external payable {
        require((msg.value == 0.01 ether), "Amount should be greater than 0.01 Ether");
        Pokemon storage _pokemon = ownerToPokemons[msg.sender][pokemonIdx];
        _pokemon.attack += 100;
    }

    // Add Defense points of selected pokemon of Msg Sender
    function addDefense(uint pokemonIdx) external payable {
        require((msg.value == 0.01 ether), "Amount should be greater than 0.01 Ether");
        Pokemon storage _pokemon = ownerToPokemons[msg.sender][pokemonIdx];
        _pokemon.defense += 100;
    }
}