// grab from our source file
const Dogs = artifacts.require('Dogs');
const Proxy = artifacts.require('Proxy');
const DogsUpdated = artifacts.require('DogsUpdated');

module.exports = async function(deployer, network, accounts) {
    // type truffle deployment logic
    const dogs = await Dogs.new();
    const proxy = await Proxy.new(dogs.address);

    // dog contract is located at this address => (proxy.address)
    //to believe that proxy contract is Dog. ProxyDog to fool Truffle
    var proxyDog = await Dogs.at(proxy.address); 
    // set # of dogs through the proxy
    await proxyDog.setNumberOfDogs(10);

    //tested
    var nrOfDogs = await proxyDog.getNumberOfDogs();
    console.log("Before update: " + nrOfDogs.toNumber());

    //Deploy new version of Dogs
    const dogsUpdated = await DogsUpdated.new();
    proxy.upgrade(dogsUpdated.address);

    //Fool truffle once again. it thinks proxyDog has all dogsUpdated functions.
    proxyDog = await DogsUpdated.at(proxy.address);
    // Initialize proxy state
    proxyDog.initialize(accounts[0]); // 1st address - own address

    // check that storage remained
    nrOfDogs = await proxyDog.getNumberOfDogs();
    console.log("After update: " + nrOfDogs.toNumber());

    //Set the nr of dogs through the proxy with NEW FUNC CONTRACT
    await proxyDog.setNumberOfDogs(30);
}