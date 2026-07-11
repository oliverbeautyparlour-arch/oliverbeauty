

const serviceSchema = new mongoose.Schema({

  serviceId: String,
  serviceName: String,
  category:String,
  durationMins: Number,
  price: Number,
description: String,
emoji:String,
});
const Service = mongoose.model("Service", serviceSchema);
app.post('/addService', async (req, res) => {
  try {
    const service = new Service({
      serviceId: req.body.serviceId,
      serviceName: req.body.serviceName,
       category:req.body.category,
  durationMins:req.body.duration,
 
description: req.body.description,
emoji:req.body.emoji,
      price: req.body.price,
    
    });

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
