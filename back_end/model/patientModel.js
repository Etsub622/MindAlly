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
    EmergencyEmail: {
        type: String,
        unique:true
    },
    Password: {
        type: String,
        required:true
    },
    Collage: {
        type: String,
    },
    EmergencyEmail: {
        type: String,
        required:true
    },
    Role: {
        type: String,
        default:"patient"
    },
   gender: {
    type: String,
   },
   preferred_modality:{
    type: String,
   },

   preferred_gender:{
    type:Array,
   },

   preferred_language: {
    type: Array
   },

   preferred_days: {
    type:Array,
   },

   preferred_mode:{
    type: Array
   },

   preferred_specialties:{
    type:Array
    },
   lastLogin: { type: Date },
   fcmToken: {
        type: String,
   },
   payout: {
    account_name: { type: String },
    account_number: { type: String },
    bank_code: { type: String },
},
})


const Patient = mongoose.model("Patient", patientschema)

export { Patient }