const admin = require('firebase-admin');

async function createAdmin() {
  try {
    const serviceAccount = require('./serviceAccountKey.json');
    
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount)
    });

    const email = 'farisalkrinawi@gmail.com';
    const password = 'faris123';
    
    console.log('🔧 Creating admin account...');
    console.log('Email:', email);
    console.log('Password:', password);
    console.log('');
    
    // Step 1: Create Firebase Auth user
    console.log('📝 Step 1: Creating Firebase Auth user...');
    const user = await admin.auth().createUser({
      email: email,
      password: password,
      emailVerified: true,
      disabled: false,
    });
    console.log('✅ User created! UID:', user.uid);
    
    // Step 2: Set admin custom claims
    console.log('\n🔑 Step 2: Setting admin custom claims...');
    await admin.auth().setCustomUserClaims(user.uid, {
      admin: true
    });
    console.log('✅ Admin claims set!');
    
    // Step 3: Create Firestore user document
    console.log('\n📄 Step 3: Creating Firestore user document...');
    const firestore = admin.firestore();
    await firestore.collection('users').doc(user.uid).set({
      email: email,
      displayName: 'Admin',
      status: 'approved',
      createdAt: new Date().toISOString(),
      approvedAt: new Date().toISOString(),
      approvedBy: 'system',
    });
    console.log('✅ Firestore document created!');
    
    console.log('\n🎉 SUCCESS! Admin account ready!');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('📧 Email:', email);
    console.log('🔒 Password:', password);
    console.log('🔗 Login URL: https://engineer-7dd06.web.app/#/admin-login');
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
  } catch (error) {
    if (error.code === 'auth/email-already-exists') {
      console.log('⚠️  User already exists, updating instead...');
      
      const user = await admin.auth().getUserByEmail('farisalkrinawi@gmail.com');
      
      // Update password
      await admin.auth().updateUser(user.uid, {
        password: 'faris123',
      });
      
      // Set admin claims
      await admin.auth().setCustomUserClaims(user.uid, {
        admin: true
      });
      
      // Create/update Firestore doc
      const firestore = admin.firestore();
      await firestore.collection('users').doc(user.uid).set({
        email: 'farisalkrinawi@gmail.com',
        displayName: 'Admin',
        status: 'approved',
        createdAt: new Date().toISOString(),
        approvedAt: new Date().toISOString(),
        approvedBy: 'system',
      }, { merge: true });
      
      console.log('✅ User updated successfully!');
      console.log('Email: farisalkrinawi@gmail.com');
      console.log('Password: faris123');
    } else {
      console.error('❌ Error:', error.message);
    }
  }
  process.exit(0);
}

createAdmin();
