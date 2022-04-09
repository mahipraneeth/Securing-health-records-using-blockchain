import web3 from "./web3";
import RecordFactory from "./build/RecordFactory.json";

const instance = new web3.eth.Contract(
  JSON.parse(RecordFactory.interface),
  "0xC79C30e4Dd421a1beE55B2c7a2579f5132C32ba3"
);

export default instance;
