import mongoose from "mongoose";


const therapistschema = new mongoose.Schema({
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
    AreaofSpecification: {
        type: String,
        required: true
    
    },
    Certificate: {
        type: String,
        required:true
    },
    Bio: {
        type:String
    },
    Fee: {
        type:Number
    },
    // Reviews: {
    //     type:[String]
    // },
    Rating: {
        type:Number
        
    },
    Role: {
        type: String,
        default:"therapist"
    },
    verified: {
        type:Boolean
    }

})


const Therapist = mongoose.model("Therapist", therapistschema)

export { Therapist }