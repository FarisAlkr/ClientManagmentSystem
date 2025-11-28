const admin = require('firebase-admin');

async function testAuth() {
  try {
    const serviceAccount = require('./serviceAccountKey.json');
    
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });

    const email = 'farisalkrinawi@gmail.com';
    
    console.log('🔍 Looking up user:', email);
    
    const user = await admin.auth().getUserByEmail(email);
    console.log('✅ User found!');
    console.log('UID:', user.uid);
    console.log('Email:', user.email);
    console.log('Email Verified:', user.emailVerified);
    console.log('Disabled:', user.disabled);
    console.log('Custom Claims:', user.customClaims);
    console.log('Last Sign In:', user.metadata.lastSignInTime);
    console.log('Creation Time:', user.metadata.creationTime);
    
    // Check Firestore user document
    const firestore = admin.firestore();
    const userDoc = await firestore.collection('users').doc(user.uid).get();
    
    if (userDoc.exists) {
      console.log('\n📄 Firestore User Document:');
      console.log(userDoc.data());
    } else {
      console.log('\n⚠️ No Firestore user document found');
    }
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
  process.exit(0);
}

testAuth();
