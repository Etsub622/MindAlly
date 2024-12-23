import mongoose from "mongoose";

const patientschema = new mongoose.Schema({
    FullName: {
        type: String,
        required:true
    },
    Email: {
        type: String,
        required:true
    },
    Password: {
        type: String,
        required:true
    },
    Collage: {
        type: String,
    
    }

})


const Patient = mongoose.model("Patient", patientschema)

export { Patient }