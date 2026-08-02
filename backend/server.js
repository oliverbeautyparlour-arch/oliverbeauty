const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
require("dotenv").config();
const { OAuth2Client } = require("google-auth-library");

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);


const app = express();

app.use(cors());
app.use(express.json())

const PORT = process.env.PORT;

const mongoUri = process.env.MONGODB_URI;

// const razorpayKey = process.env.RAZORPAY_KEY_ID;
// const razorpaySecret = process.env.RAZORPAY_KEY_SECRET;
// const razorpay = new Razorpay({
//     key_id: razorpayKey,
//     key_secret: razorpaySecret
// });
// app.post("/createOrder", async (req, res) => {
//   try {
//     const { amount } = req.body;
//     if (!amount || amount <= 0) {
//       return res.status(400).json({
//         success: false,
//         message: "Invalid amount"
//       });
//     }
//     // const order = await razorpay.orders.create({
//     //   amount: amount * 100,
//     //   currency: "INR",
//     //   receipt: "receipt_" + Date.now(),
//     // });
//     // res.json(order);
//   } catch (err) {
//     res.status(500).json({
//       success: false,
//       message: err.message,
//     });
//   }
// });

const userauth = new mongoose.Schema({

  name: {
    type: String,
    required: true,
  },

  email: {
    type: String,
    required: true,
    unique: true,
  },

  password: {
    type: String,
    default: null,
  },

  googleId: {
    type: String,
    default: null,
  },

  profilePic: {
    type: String,
    default: "",
  },

  provider: {
    type: String,
    default: "local",
  }

});

const Auth = mongoose.model("Auth", userauth);
app.post("/login", async (req, res) => {
  try {
    const { name, password } = req.body;

    // Admin Login
    if (name === "admin" && password === "12345") {
      return res.status(200).json({
        success: true,
        role: "admin",
        message: "Admin Login Successful",
      });
    }

    // User Login
    const user = await Auth.findOne({
      name,
      password,
    });

    if (!user) {
      return res.status(401).json({
        success: false,
        message: "Invalid username or password",
      });
    }

    res.status(200).json({
      success: true,
      role: "user",
      message: "Login Successful",
      user,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});
app.get("/profile/:id", async (req, res) => {
  try {
    const user = await Auth.findById(req.params.id).select("name email");

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    res.status(200).json({
      success: true,
      data: user,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});
app.put('/updateService/:serviceId', async (req, res) => {
  try {
    const updated = await Service.findOneAndUpdate(
      { serviceId: req.params.serviceId },
      req.body,
      { new: true }
    );

    if (!updated) {
      return res.status(404).json({
        success: false,
        message: "Service not found"
      });
    }

    res.status(200).json({
      success: true,
      message: "Service updated successfully",
      data: updated
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});
app.put("/updateProfile/:id", async (req, res) => {
    console.log("Update Profile API Called");
  console.log(req.params.id);
  console.log(req.body);
  try {
    const { name, email } = req.body  ;

    // Check if another user already has this email
    const existingUser = await Auth.findOne({
      email,
      _id: { $ne: req.params.id },
    });

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: "Email already exists",
      });
    }

    const updatedUser = await Auth.findByIdAndUpdate(
      req.params.id,
      {
        name,
        email,
      },
      { new: true }
    );

    if (!updatedUser) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    res.status(200).json({
      success: true,
      message: "Profile Updated",
      user: updatedUser,
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
});
app.post("/signup", async (req, res) => {
  try {
const existingUser = await Auth.findOne({

     email: req.body.email ,
  
  
});

if (existingUser) {
  return res.status(400).json({
    success: false,
    message: "Email already exists, Try Login"
  });
}else{
    const user = new Auth(req.body);

    const savedUser = await user.save();

    res.status(201).json({
      success: true,
      message: "Account Created",
      data: savedUser,
    });

  }} catch (error) {

    res.status(500).json({
      success: false,
      message: error.message,
    });

  }
});
app.post("/googleLogin", async (req, res) => {
  try {

    const { idToken } = req.body;

    const ticket = await client.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });

    const payload = ticket.getPayload();

    const googleId = payload.sub;
    const email = payload.email;
    const name = payload.name;
    const picture = payload.picture;

    let user = await Auth.findOne({ email });

    if (!user) {

      user = new Auth({
        name,
        email,
        googleId,
        profilePic: picture,
        provider: "google",
      });

      await user.save();

    } else {

      user.googleId = googleId;
      user.profilePic = picture;
      user.provider = "google";

      await user.save();

    }

    res.json({
      success: true,
      message: "Google Login Successful",
      user,
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      message: error.message,
    });

  }
});

const bookingSchema = new mongoose.Schema({

  userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Auth",
        required: true,
    },


  serviceId: {
    type: String,
    required: true
  },

  serviceName: {
    type: String,
    required: true
  },

  bookedPrice: {
    type: Number,
    required: true
  },

  bookedDuration: {
    type: Number,
    required: true
  },

  bookingDateTime: {
    type: Date,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }

});
app.get("/dashboard", async (req, res) => {
  try {
    const totalBookings = await Booking.countDocuments();

    const totalCustomers = await Booking.distinct("userId");
    // or "email" if you don't store userId

    const totalServices = await Service.countDocuments();

    const revenue = await Booking.aggregate([
      {
        $group: {
          _id: null,
          total: { $sum: "$amount" }   // amount paid
        }
      }
    ]);

    res.json({
      totalBookings,
      totalCustomers: totalCustomers.length,
      totalServices,
      revenue: revenue.length == 0 ? 0 : revenue[0].total
    });

  } catch (e) {
    res.status(500).json({ error: e.toString() });
  }
});
const Booking = mongoose.model("Booking", bookingSchema);
app.post("/booking", async (req, res) => {
  try {
    const booking = new Booking(req.body);

    const savedBooking = await booking.save();

    res.status(201).json({
      success: true,
      message: "Booking created successfully",
      data: savedBooking,
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      message: error.message,
    });

  }
});
app.get("/getBookings/:userId", async (req, res) => {
  try {

    const bookings = await Booking.find({
      userId: req.params.userId
    });

    res.status(200).json({
      success: true,
      data: bookings,
    });

  } catch (error) {

    res.status(500).json({
      success: false,
      message: error.message,
    });

  }
});

app.get('/TopFive', async (req, res) => { 
  try {
 
    const topFive = await Booking.aggregate([
      {
        $group: {
       _id: "$serviceId",
          totalBookings: { $sum: 1 }
        }
      },
      {
        $sort: {
          totalBookings: -1
        }
      },
      {
        $limit: 5
      },
      {
       
  $lookup:{
      from:"services",
      localField:"_id",
      foreignField:"serviceId",
      as:"service"
  }

      },
    
      {
        $unwind: "$service"
      },
      {
        $project: {
          _id: 0,
          totalBookings: 1,
          serviceId: "$service.serviceId",
          serviceName: "$service.serviceName",
          category: "$service.category",
          durationMins: "$service.durationMins",
          price: "$service.price",
          description: "$service.description",
          image: "$service.image"
        }
      }
    ]);

    res.status(200).json({
      success: true,
      data: topFive
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});
app.post('/addBookings', async (req, res) => {

    try{

        const booking = new Booking(req.body);

        await booking.save();

        res.status(201).json({

            success:true,

            data:booking

        });

    }

    catch(error){

        res.status(500).json({

            success:false,

            message:error.message

        });

    }

});
app.get('/dateandtime', async (req, res) => {
  try {
    const { date } = req.query;

    const bookings = await Booking.find(
      { bookingDate: date },
      { bookingTime: 1, _id: 0 }
    );

    res.status(200).json(bookings);
  } catch (error) {
    res.status(500).json({
      message: error.message
    });
  }
});
//service storeing
const serviceSchema = new mongoose.Schema({
  serviceId: {
    type: String,
    required: true,
    unique: true
  },
  serviceName: {
    type: String,
    required: true
  },
  category: {
    type: String,
    required: true
  },
  durationMins: {
    type: Number,
    required: true
  },
  price: {
    type: Number,
    required: true
  },
  description: String,
    image:String,
});
const Service = mongoose.model("Service", serviceSchema);
app.post('/addService', async (req, res) => {
  try {
    const service = new Service(
             req.body

);

    const savedService = await service.save();


    res.status(201).json({
      message: "Service added successfully",
      data: savedService
    });

  } catch (error) {
    res.status(500).json({
      message: "Error saving service",
      error: error.message
    });
  }
});
app.get('/getService',async(req, res)=>{
  try{
    const services = await Service.find();
    res.status(200).json({
      success: true,
      data: services
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  
  }
});





const uri = mongoUri;


const connectDB = async () => {
  try {
    await mongoose.connect(uri
    
    );

    console.log("MongoDB Connected");
  } catch (error) {
    console.log(error);
  }
};

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
    connectDB();
});