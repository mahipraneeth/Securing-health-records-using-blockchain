import web3 from "./web3";
import compiledRecord from "./build/healthrecord.json";

export default (address) => {
  return new web3.eth.Contract(JSON.parse(compiledRecord.interface), address);
};
