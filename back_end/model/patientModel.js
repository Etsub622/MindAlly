import mongoose from "mongoose";

const patientschema = new mongoose.Schema({
    FullName: {
        type: String,
        required:true
    },
    Email: {
        type: String,
        required: true,
        unique:true
        
    },
    Password: {
        type: String,
        required:true
    },
    Collage: {
        type: String,
    
    },
    Role: {
        type: String,
        default:"patient"
    }
 

})


const Patient = mongoose.model("Patient", patientschema)

export { Patient }