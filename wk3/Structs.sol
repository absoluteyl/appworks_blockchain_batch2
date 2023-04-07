// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ref: https://www.youtube.com/watch?v=pQJ4TeHifdk

contract Structs {
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;

    // define a mapping for owner of cars
    mapping(address => Car[]) public carsByOwner;

    function examples() external {
        // Ways to decalre variable with Struct:
        // 1. attributes of the Car needs to be exact the same sequnce as defined in Struct
        Car memory toyota = Car("Toyota", 1990, msg.sender);

        // 2. attributes can be in different order since we also assign values to exact keys
        Car memory lambo  = Car({year: 1980, model: "Lamborghini", owner: msg.sender});

        // 3. multi-lines declaration
        Car memory tesla;
        tesla.model = "Tesla";
        tesla.year = 2010;
        tesla.owner = msg.sender;

        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);
        
        // declare a car with Car struct and push it into cars array in one line.
        cars.push(Car("Ferrari", 2020, msg.sender));

        // variables declared with memory will disappear after function excuted
        Car memory _firstCar = cars[0];
        _firstCar.model;
        _firstCar.year;
        _firstCar.owner;

        // variables declared with storage will actually store on the blockchain
        Car storage _secondCar = cars[1];
        _secondCar.year = 1999; // update value of year
        delete _secondCar.owner ; // value of owner will be reset to default value (which is 0x0...00 address)

        // delete entire car struct
        delete cars[2];
    }
}