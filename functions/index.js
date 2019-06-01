const functions = require('firebase-functions');

const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });

// Adds a message that welcomes new users into the chat.
exports.addWelcomeMessages = functions.auth.user().onCreate(async (user) => {
  console.log('A new user signed in for the first time.');
  const fullName = user.displayName || 'Anonymous';

  // Saves the new welcome message into the database
  // which then displays it in the FriendlyChat clients.
  await admin.firestore().collection('/test/{postid}/test2').add({
    name: 'Firebase Bot testing',
    profilePicUrl: '/images/firebase-logo.png', // Firebase logo
    text: `${fullName} signed in for the first time! Welcome!`,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    likes_count: '0'
  });
  console.log('Welcome message written to database.');
});


exports.countlikechange = functions.database.ref('/posts/{postid}/likes/{likeid}').onWrite(
    async (change) => {
      const collectionRef = change.after.ref.parent;
      const countRef = collectionRef.parent.child('likes_count');

      let increment;
      if (change.after.exists() && !change.before.exists()) {
        increment = 1;
      } else if (!change.after.exists() && change.before.exists()) {
        increment = -1;
      } else {
        return null;
      }

      // Return the promise from countRef.transaction() so our function
      // waits for this async event to complete before it exits.
      await countRef.transaction((current) => {
        return (current || 0) + increment;
      });
      console.log('Counter updated.');
      return null;
    });


    exports.makeUppercase = functions.firestore.document('/testwrite/{documentId}/tests')
    .onCreate((snap, context) => {
// [END makeUppercaseTrigger]
      // [START makeUppercaseBody]
      // Grab the current value of what was written to the Cloud Firestore.
      const original = snap.data().original;
      console.log('Uppercasing', context.params.documentId, original);
      const uppercase = original.toUpperCase();
      // You must return a Promise when performing asynchronous tasks inside a Functions such as
      // writing to the Cloud Firestore.
      // Setting an 'uppercase' field in the Cloud Firestore document returns a Promise.
      return snap.ref.set({uppercase}, {merge: true});
      // [END makeUppercaseBody]
    });