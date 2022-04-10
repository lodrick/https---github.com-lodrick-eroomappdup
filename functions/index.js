const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotification = functions.firestore
    .document('messages/{groupId1}/{groupId2}/{message}')
    .onCreate((snap, context) => {
      console.log("----------------start function--------------------");

      const doc = snap.data();
      console.log("start function");
      const idFrom = doc.idFrom;
      const idTo = doc.idTo;
      const contentMessage = doc.message;

      console.log(idFrom);
      console.log(idTo);

      // Get push token user to (receive)
      admin.firestore()
        .collection("users")
        .where("idUser", "==", idTo)
        .get()
        .then((querySnapshot) => {
          querySnapshot.forEach((userTo) => {

            console.log("Found user to: " + userTo.data().name);

            if (userTo.data().token) {
              
              // Get info user from (sent)
              admin
                .firestore()
                .collection("users")
                //.where("idUser", "==", idFrom)
                .where("idUser","==", idFrom)
                .get()
                .then((querySnapshot2) => {
                  querySnapshot2.forEach((userFrom) => {
                    console.log("Found user from: " + userFrom.data().name);
                    console.log("contentMessage: " + JSON.stringify(contentMessage))

                    const payload = {
                      'notification': {
                        title: userFrom.data().name,
                        body: contentMessage,
                        badge: "1",
                        sound: "default",
                      },
                    };

                    admin
                      .messaging()
                      .sendToDevice(userTo.data().token, payload)
                      .then((response) => {
                        console.log("Successfully sent message: ", response);
                      })
                      .catch((error) => {
                        console.log("Error sending message: ", error);
                      });
                    });
                  });
            } else {
              console.log("Can not find token target user");
            }
          });
        });
        console.log("|----------------End function--------------------|");
        return null
    });
