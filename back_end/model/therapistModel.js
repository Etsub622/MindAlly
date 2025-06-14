
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
    modality: {
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
    ratings: [{ type: Number }],
    averageRating: { type: Number, default: 0.0 },
    gender: {
        type: String,
    },
    Role: {
        type: String,
        default:"pending_therapist"
    },
    verified: {
        type:Boolean,
        default: false,
    },
    specialities: {
        type: Array
    },
    available_days: {
        type: Array
    },
    language:{
        type: Array
    },
    mode: {
        type: Array
    },
    experience_years:{
        type: Number,
        default: 0,
    },
    wallet: {
        type: Number,
        default: 0,
    },
    profilePicture: {
        type: String,
        default: ""
    },
    payout: {
        account_name: { type: String },
        account_number: { type: String },
        bank_code: { type: String },
    },
    lastLogin: { type: Date }

})


const Therapist = mongoose.model("Therapist", therapistschema)

export { Therapist }