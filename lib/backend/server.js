const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');

const app = express();

app.use(cors());
app.use(express.json())


const Razorpay = require("razorpay");

const razorpay = new Razorpay({
    key_id: "rzp_test_TCnTh1rAxY23i3",
    key_secret: "Ona4g0rZwmkrzNUb3WOI1jtn"
});
app.post("/createOrder", async (req, res) => {
  try {
    const { amount } = req.body;

    if (!amount || amount <= 0) {
      return res.status(400).json({
        success: false,
        message: "Invalid amount"
      });
    }

    const order = await razorpay.orders.create({
      amount: amount * 100,
      currency: "INR",
      receipt: "receipt_" + Date.now(),
    });

    res.json(order);
  } catch (err) {
    res.status(500).json({
      success: false,
      message: err.message,
    });
  }
});

const userauth = new mongoose.Schema({
  email:{
   type: String,
  required: true,
},
  password: {type: String,
required: true,
  },
  name: String,
 
})

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
//app.use("/addService", require("./service.js"));
const bookingSchema = new mongoose.Schema({

  // bookingId: {
  //   type: Number,
  //   unique: true
  // },

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

  paymentType: {
    type: String,
    default: "Cash"
  },

  status: {
    type: String,
    default: "Pending"
  },

  createdAt: {
    type: Date,
    default: Date.now
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
app.get('/getBookings',async (req,res)=>{
try{
  const book = await Booking.find();
  res.status(200).json({
      success: true,
      data: book
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
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




//const uri = "mongodb+srv://selvasindhuja:sindhu1012@userdb.4gjmguy.mongodb.net/?appName=UserDB";
const uri = "mongodb+srv://oliverbeautyparlour_db_user:oliverbeauty12345@oliverbp.ljiijld.mongodb.net/?appName=OliverBP";


const connectDB = async () => {
  try {
    await mongoose.connect(uri
    
    );

    console.log("MongoDB Connected");
  } catch (error) {
    console.log(error);
  }
};

app.listen(3000, '0.0.0.0', () => {
    console.log("Server running on port 3000");
    connectDB();
});