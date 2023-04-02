// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// 製作一款寶可夢遊戲
// 一個寶可夢需要有名稱，攻擊與防禦這三種屬性
// 根據地址，可以查詢到該玩家所擁有的寶可夢
// 一個玩家可以有多個寶可夢
// 需要有一個 create 的方法來創造出寶可夢
// （optional) 可付費 0.1 ETH 來增加該玩家所擁有的特定寶可夢的攻擊或是防禦

// library PokemonHelper {
    // function find(
    //     uint[] memory arr,
    //     uint x
    // ) internal view returns (uint) {
    //     for(uint i = 0; i < arr.length; i++) {
    //         if(arr[i] == x) {
    //             return i;
    //         }
    //     }
    //     revert("Not Found.");
    // }

//     function findByName(
//         string[] storage arr,
//         string str
//     ) internal view returns (uint) {
//         for(uint i = 0; i < arr.length; i++) {
//             if(keccak256(abi.encodePacked(arr[i])) == keccak256(abi.encodePacked(str))) {
//                 return i;
//             }
//         }
//         revert("Not Found.");
//     }
// }

contract PokemonGame {
    struct Pokemon {
        uint   id;      // Unique ID amount all pokemons.
        string name;    // Pokemon Name given by owner.
        uint   attack;  // Attack Points.
        uint   defense; // Defense Points.
    }

    Pokemon[] public pokemons;
    mapping (address => uint[]) public ownerToPokemonIds;

    // Pokemon Helper
    function findByName(string calldata _name) internal view returns (uint) {
        for(uint i = 0; i < pokemons.length; i++) {
            if(keccak256(abi.encodePacked(pokemons[i].name)) == keccak256(abi.encodePacked(_name))) {
                return i;
            }
        }
        revert("Not Found.");
    }

    // Create Pokemon for Msg Sender
    function create(string calldata _name) external {
        // Generate random attack, defense points.
        uint _attack = uint(keccak256(abi.encodePacked(_name))) % 1000 * 5;
        uint _defense = uint(keccak256(abi.encodePacked(_name))) % 100 * 60;

        // Init the pokemon
        uint _id = pokemons.length + 1;
        Pokemon memory _pokemon = Pokemon(_id, _name, _attack, _defense);

        // Add it to sender's collection.
        pokemons.push(_pokemon);
        ownerToPokemonIds[msg.sender].push(_id);
    }

    // List all Pokemons of Msg Sender
    function listMyPokemons() external view returns (uint[] memory) {
        return ownerToPokemonIds[msg.sender];
    }

    // Add Attack points of selected pokemon of Msg Sender
    function addAttack(string calldata _name) external payable {
        require((msg.value == 0.01 ether), "Amount should be 0.01 Ether");
        
        uint _idx = findByName(_name);
        Pokemon storage _pokemon = pokemons[_idx];
        _pokemon.attack += 100;
    }

    // Add Defense points of selected pokemon of Msg Sender
    function addDefense(string calldata _name) external payable {
        require((msg.value == 0.01 ether), "Amount should be 0.01 Ether");
        
        uint _idx = findByName(_name);
        Pokemon storage _pokemon = pokemons[_idx];
        _pokemon.defense += 100;
    }
}