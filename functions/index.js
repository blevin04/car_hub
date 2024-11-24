/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//  const {onRequest} = require("firebase-functions/v2/https");
//  const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const functions = require("firebase-functions");

admin.initializeApp();
exports.newMessage = functions.firestore.
    onDocumentCreated("rooms/{roomId}/messages/{message}",
        async (snapshot) => {
          const textdata = snapshot.data;
          const roomdoc = await admin.firestore().
              collection("rooms").doc(snapshot.params.roomId).
              get();
          const roomName = roomdoc.data().Name;
          const senderId = textdata.data().sender;
          const senderdoc = await admin.firestore().
              collection("users").doc(senderId).get();
          const senderName = senderdoc.data().fullName;

          const message = {

            notification: {

              title: `New message from ${roomName}`,

              body: `${senderName}: ${textdata.data().message}`,
            },
            topic: snapshot.params.roomId,
          };

          admin.messaging().send(message).then((response)=>{
            console.log("Successfully sent notification", response);
          }).catch((error)=>{
            console.log("error sending message", error);
          });
        });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
