const admin = require('firebase-admin');
const readline = require('readline');

// Initialize readline interface
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Function to prompt user for input
function prompt(question) {
  return new Promise((resolve) => {
    rl.question(question, resolve);
  });
}

async function setupAdmin() {
  try {
    console.log('🔥 Firebase Admin Setup Script');
    console.log('================================\n');

    // Check if service account key exists
    let serviceAccountPath;
    try {
      serviceAccountPath = './serviceAccountKey.json';
      const serviceAccount = require(serviceAccountPath);

      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
      });

      console.log('✅ Firebase Admin initialized successfully\n');
    } catch (error) {
      console.log('❌ Service account key not found!');
      console.log('Please download your service account key from:');
      console.log('Firebase Console → Project Settings → Service Accounts → Generate New Private Key');
      console.log('Save it as "serviceAccountKey.json" in this directory\n');

      const retry = await prompt('Do you want to try again? (y/n): ');
      if (retry.toLowerCase() !== 'y') {
        process.exit(1);
      }

      // Try again
      const serviceAccount = require('./serviceAccountKey.json');
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount)
      });
    }

    // Get admin email
    const email = await prompt('Enter admin email address: ');

    if (!email || !email.includes('@')) {
      console.log('❌ Invalid email address');
      process.exit(1);
    }

    console.log(`\n🔍 Looking up user: ${email}`);

    // Get user by email
    const user = await admin.auth().getUserByEmail(email);
    console.log(`✅ User found: ${user.uid}`);

    // Set custom claims
    await admin.auth().setCustomUserClaims(user.uid, {
      admin: true
    });

    console.log(`\n🎉 SUCCESS! Admin claim set for ${email}`);
    console.log(`User UID: ${user.uid}`);
    console.log('\nThe user can now log into the admin panel!');

    // Verify the claims
    const userRecord = await admin.auth().getUser(user.uid);
    console.log('\n✅ Verification:');
    console.log('Custom claims:', userRecord.customClaims);

  } catch (error) {
    console.error('\n❌ Error setting up admin:', error.message);

    if (error.code === 'auth/user-not-found') {
      console.log('\n💡 The user needs to register in the app first!');
      console.log('1. Go to your app');
      console.log('2. Create an account with this email');
      console.log('3. Run this script again');
    }
  } finally {
    rl.close();
    process.exit(0);
  }
}

// Run the setup
setupAdmin();