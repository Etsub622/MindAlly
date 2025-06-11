import mongoose from "mongoose";

const adminschema = new mongoose.Schema({
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
    Role: {
        type: String,
        default:"admin"
    },


})


const Admin = mongoose.model("Admin", adminschema)

export { Admin }