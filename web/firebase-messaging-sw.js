importScripts(
  "https://www.gstatic.com/firebasejs/9.9.0/firebase-app-compat.js"
);
importScripts(
  "https://www.gstatic.com/firebasejs/9.9.0/firebase-messaging-compat.js"
);

firebase.initializeApp({
  apiKey: "AIzaSyDTpboiv2AwrLb2OZtcCP8LrLHx1YKAcOo",
  authDomain: "crowd-snap.firebaseapp.com",
  databaseURL:
    "https://crowd-snap-default-rtdb.europe-west1.firebasedatabase.app",
  projectId: "crowd-snap",
  storageBucket: "crowd-snap.appspot.com",
  messagingSenderId: "971504465078",
  appId: "1:971504465078:web:ee11b3c2fa4ef041c02217",
  measurementId: "G-FTZ2RLE8YF",
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});
