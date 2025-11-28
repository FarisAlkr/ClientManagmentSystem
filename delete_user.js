const admin = require('firebase-admin');

async function deleteUser() {
  try {
    const serviceAccount = require('./serviceAccountKey.json');

    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });

    const email = 'farisalkrinawi@gmail.com';

    console.log('🔍 Looking up user:', email);

    try {
      const user = await admin.auth().getUserByEmail(email);
      console.log('✅ User found! UID:', user.uid);

      // Delete from Firebase Auth
      await admin.auth().deleteUser(user.uid);
      console.log('✅ Deleted from Firebase Auth');

      // Delete from Firestore
      const firestore = admin.firestore();
      await firestore.collection('users').doc(user.uid).delete();
      console.log('✅ Deleted from Firestore');

      console.log('\n🎉 User completely deleted!');
    } catch (error) {
      if (error.code === 'auth/user-not-found') {
        console.log('ℹ️  User does not exist, nothing to delete');
      } else {
        throw error;
      }
    }

  } catch (error) {
    console.error('❌ Error:', error.message);
  }
  process.exit(0);
}

deleteUser();
