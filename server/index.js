const express=require('express');
var http=require("http");
const app=express();
const port=process.env.PORT || 3000;
var server=http.createServer(app);
const mongoose=require("mongoose");
const Room=require('./models/room');
const getWord=require('./apis/get_woed');
var io=require("socket.io")(server);


//middleware
app.use(express.json());

//connect mongoDb
const DB="mongodb+srv://praveen:praveen123@cluster0.v9ku4.mongodb.net/";

mongoose.connect(DB).then(()=>{
    console.log("Connection Successfull");
}).catch((e)=>{
    console.log(e);
});

io.on('connection',(socket)=>{
    console.log('connected');
    socket.on('create-game',async({nickname,name,occupancy,maxRound})=>{
        try{
 const existingRoom=await Room.findOne({name});
 if(existingRoom){
    socket.emit('notCorrectGame','Room with the game already exists !.');
    return;
 }

 let room=new Room();
 const word=getWord();
 room.word=word;
 room.name=name;
 room.occupancy=occupancy;
 room.maxRound=maxRound;

 let player={
    socketId:socket.id,
    nickname,
    ispartyLeader:true,

 }

 room.players.push(player);
 room=await room.save();
 socket.join(name);
 io.to(name).emit('updateRoom',room); 
        }catch (error){
           console.log(error) ;
        }
    });

    //Join room socket
   socket.on('join-game',async({nickname,name})=>{
    try {
        let room =await Room.findOne({name});
        if(!room){
            socket.emit('notCorrectGame','Room with the game does not exists !.');
            return;   
        }

       console.log(room.isJoin);
        if(room.isJoin){
            let player={
                socketId:socket.id,
                nickname
            }
            room.players.push(player);
            
            console.log("turned to true");
            if(room.players.length === room.occupancy){
                console.log("turned to false");
                 room.isJoin=false;
            }

            room.turn=room.players[room.turnIndex];
            room=await room.save();
            socket.join(name);
            io.to(name).emit('updateRoom',room);
        }else{
            console.log("Not in game");
            socket.emit('notCorrectGame','The game is in progress,Please try later !.')
        }
    } catch (error) {
        console.log(error);
    }
   });

   //paint 

   socket.on('paint',({details,roomName})=>{
    io.to(roomName).emit('points',{details:details});
   })



});


server.listen(port,"0.0.0.0",()=>{
    console.log("Server Started and running on"+port);
})