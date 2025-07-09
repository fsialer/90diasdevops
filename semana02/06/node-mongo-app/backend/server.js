const express = require('express');
const mongoose = require('mongoose');
const app = express();

mongoose.connect('mongodb://db:27017/mydb');

app.get('/', (req, res) => {
  res.send('¡API conectada a MongoDB con Docker!');
});

app.listen(3000, () => console.log('Server running on port 3000'));