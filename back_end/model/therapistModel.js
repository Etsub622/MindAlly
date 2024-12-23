import mongoose from "mongoose";

const therapistschema = new mongoose.Schema({
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
    AreaofSpecification: {
        type: String,
        required: true
    
    }

})


const Therapist = mongoose.model("Therapist", therapistschema)

export { Therapist }