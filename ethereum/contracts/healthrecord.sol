pragma solidity ^0.4.17;
contract RecordFactory{
    address[] public deployedrecords;
    mapping(address=>bool) public records;
    address public manager ;
    
    struct Doctor{
        address doc;
        string imageHash;
        string speciality;
        string description;
        
    }
    
    function RecordFactory() public {
        manager=msg.sender;
    }
    
    mapping(address=>Doctor) public docs;
    
    address[] public doctors;

    function createRecord(string name,string age,string gender,string height,string weight,address doctorAddress,string prescriptionHash,string mriHash,string imageHash) public {
        require(!records[msg.sender]);
        healthrecord newRecord = new healthrecord(msg.sender,name,age,gender,height,weight,doctorAddress,imageHash);
        records[msg.sender]=true;
        deployedrecords.push(address(newRecord));
        if(bytes(mriHash).length!=0){
            newRecord.setreportHash(doctorAddress,mriHash);
        }
        if(bytes(prescriptionHash).length!=0){
            newRecord.setPrescriptionHash(doctorAddress,prescriptionHash);
        }
    }

    function getDeployedRecords() public view returns(address[]){
        return deployedrecords;
    }
    
    function registerDoctor(address sender,string _imageHash,string _speciality,string _description) public{
        require(msg.sender==manager);
        Doctor memory doc = Doctor({
            doc:sender,
            imageHash:_imageHash,
            speciality:_speciality,
            description:_description
        });
        docs[sender]=doc;
        doctors.push(sender);
    }
    
    function getDoctors() public view returns(address[]){
        return doctors;
    }
}

contract healthrecord{
    string[] private prescriptionHash;
    string[] private reportHash;
    string private profileHash;
    address private manager;
    address private doctor;
    string private name;
    string private age;
    string private gender;
    string private height;
    string private weight;
    
    function healthrecord(address owner,string _name,string _age,string _gender,string _height,string _weight,address doctorAddress,string _profileHash) public{
        manager=owner;
        name=_name;
        age=_age;
        gender=_gender;
        height=_height;
        weight=_weight;
        doctor=doctorAddress;
        profileHash=_profileHash;
    }
    
    modifier restricted(){
         require(msg.sender==manager||msg.sender==doctor);
         _;
    }

    function setPrescriptionHash(address sender,string hash) public{
        require(sender==doctor);
        prescriptionHash.push(hash);
    }
    
    function setreportHash(address sender,string hash) public{
        require(sender==doctor);
        reportHash.push(hash);
    }
    
    function getNameandAddress() public view returns(string,string,address,address){
        return (name,profileHash,manager,doctor);
    }
    
    function getDetails() restricted public view returns(string,string,string,string,string){
        return (name,age,height,weight,gender);
    }
    
    function getPrescription(uint index) restricted public view returns(string){
        return prescriptionHash[index];
    }
    
    function getPrescriptionLength() restricted public view returns(uint){
        return prescriptionHash.length;
    }
    
    
    function getReport(uint index) restricted public view returns(string){
        return reportHash[index];
    }
    
    function getReportLength() restricted public view returns(uint){
        return reportHash.length;
    }

}